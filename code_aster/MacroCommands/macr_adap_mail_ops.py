# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: gerald.nicolas at edf.fr
#
"""
Traitement des macros MACR_ADAP_MAIL/MACR_INFO_MAIL
"""
__revision__ = "V3.1"
#
import os
import pickle
import shutil
import tarfile
from glob import glob

import aster

from ..Cata.Syntax import _F
from ..Commands import (DEFI_FICHIER, EXEC_LOGICIEL, IMPR_RESU, LIRE_CHAMP,
                        LIRE_MAILLAGE)
from ..Helpers.UniteAster import UniteAster
from ..Messages import UTMESS, MasquerAlarme, RetablirAlarme
from ..Supervis import Serializer
from ..Utilities import ExecutionParameter, logger
from .Utils import creation_donnees_homard

EnumTypes = (list, tuple)


class HomardInfo:
    """Object that holds the informations needed by Homard and *reused* by
    successive calls to MACR_ADAP_MAIL.

    *This is an incomplete refactoring of the legacy operator.*

    The `Serializer` isn't able to store every complex objects containing
    *DataStructure* objects, only *list* and *dict*.

    The needed informations between successive calls are the mesh objects and
    the fields to be interpolated or used as refinement indicator.
    Pointers to the needed *DataStructure* objects are kept in `objects`
    attribute (as a *dict* to be serialized).
    The informations are stored into `run_params` attribute. In this object,
    all references to *DataStructure* are replaced by their names to be
    pickable.
    When it is required, *DataStructure* objects are injected to make the data
    used as in legacy operator.
    """
    _objects = {}
    _run_params = []
    _run_idx = 0

    @classmethod
    def new_run(cls):
        cls._run_idx += 1
        return cls._run_idx

    @property
    def objects(self):
        """Attribute that contains the stored objects."""
        return self._objects

    @property
    def run_params(self):
        """Attribute that contains the runs parameters."""
        return self._run_params

    def store_object(self, datastr):
        """Store a DataStructure for reusability.

        Arguments:
            datastr (*DataStructure*): *DataStructure* object.
        """
        name = datastr.getName()
        if name in self._objects:
            previous = self._objects[name].getName()
            if previous != name:
                print("Warning: object {0} already exist".format(name))
        self._objects[name] = datastr

    def get_object(self, name):
        """Return the object known as `name`.

        Arguments:
            name (str): Object name.

        Returns:
            *DataStructure*: Object as previously stored.
        """
        return self._objects[name]

    def field_data_to_name(self, field_data):
        """Replace *DataStructure* by their names.

        Arguments:
            field_data (dict): Properties of a field.

        Returns:
            dict: New *dict* where *DataStructure* have been replaced by
            their names.
        """
        data_with_names = dict()
        data_with_names.update(field_data)
        for key in ("RESULTAT", "CHAM_GD"):
            if key in field_data:
                self.store_object(field_data[key])
                data_with_names[key] = field_data[key].getName()
        return data_with_names

    def store_fields_data(self, fields_data):
        """Store *DataStructure* in known objects and return data containing
        only the objects names.

        Arguments:
            fields_data (list): Fields data containing *DataStructure*.

        Returns:
            list: Fields data where *DataStructure* have been replaced by
            objects names.
        """
        return [self.field_data_to_name(data) for data in fields_data]

    def field_data_to_object(self, data_with_names):
        """Replace names by *DataStructure* objects.

        Arguments:
            data_with_names (dict): Properties of a field.

        Returns:
            dict: New *dict* with *DataStructure* objects."""
        field_data = dict()
        field_data.update(data_with_names)
        for key in ("RESULTAT", "CHAM_GD"):
            if key in data_with_names:
                field_data[key] = self.get_object(data_with_names[key])
        return field_data

    def get_fields_data(self, data_with_names):
        """Return fields properties with *DataStructure* objects."""
        return [self.field_data_to_object(data) for data in data_with_names]

    def load_runs(self, Rep_Calc_ASTER):
        """Load the previously stored data."""
        wrkdir = os.getcwd()
        #   On prend le fichier pickle du 1er répertoire (ce sont tous les memes),
        #   puis on recupere la liste des passages
        base = glob("*_ADAP_*")[0]
        os.chdir(os.path.join(Rep_Calc_ASTER, base))
        context = {}
        Serializer(context).load()
        os.chdir(wrkdir)

        logger.info("Loaded objects from homard history:")
        for obj in context['objects'].values():
            self.store_object(obj)
            logger.info(f"{obj.getName():<24s} {obj}")

        for dico in context['runs']:
            Rep_Calc_HOMARD_local = dico["Rep_Calc_HOMARD_local"]
            dico["Rep_Calc_HOMARD_global"] = os.path.abspath(Rep_Calc_HOMARD_local)
            self._run_params.append(dico)

    def save_runs(self):
        """Save the data of the existing runs.

        Returns:
            list: List of saved subdirectories.
        """
        # it probably saves the same content several times...
        dirs = []
        for dico in self._run_params:
            Rep_Calc_HOMARD_local = dico["Rep_Calc_HOMARD_local"]
            dirs.append(Rep_Calc_HOMARD_local)
            Rep_Calc_HOMARD_global = dico["Rep_Calc_HOMARD_global"]
            wrkdir = os.getcwd()
            os.chdir(Rep_Calc_HOMARD_global)
            context = {}
            context['objects'] = ginfos.objects
            context['runs'] = ginfos.run_params
            pickler = Serializer(context)
            pickler.save()
            logger.info("Saved objects for homard history:")
            for obj in ginfos.objects.values():
                logger.info(f"{obj.getName():<24s} {obj}")

            os.chdir(wrkdir)
        return dirs

    def init_run_params(self, INFO, fichier_archive, Rep_Calc_ASTER):
        """Initialisation de la liste des passages, eventuellement apres
        extraction de l'archive.

        Arguments:
            INFO : niveau d'information pour la macro-commande
            fichier_archive : nom de l'eventuel fichier d'archive des cas precedents
            Rep_Calc_ASTER : répertoire de calcul d'Aster
        """
        if INFO >= 3:
            print("\nDans init_run_params, fichier_archive :", fichier_archive)
        #
        # A.0. A priori, la liste est vide
        #
        # A.1. S'il existe un fichier de reprise, c'est que l'on est au premier
        #      appel apres une 'poursuite' ou un 'debut' avec les historiques.
        #      On recupere les répertoires qui auraient pu etre archives au calcul precedent.
        #
        if os.path.isfile(fichier_archive):
        #
        # A.1.1 Extraction  des fichiers selon leur type
        # Remarque : a partir de python 2.5 on pourra utiliser extractall
        #
            with tarfile.open(fichier_archive, "r") as tar:
                def is_within_directory(directory, target):
                    
                    abs_directory = os.path.abspath(directory)
                    abs_target = os.path.abspath(target)
                
                    prefix = os.path.commonprefix([abs_directory, abs_target])
                    
                    return prefix == abs_directory
                
                def safe_extract(tar, path=".", members=None, *, numeric_owner=False):
                
                    for member in tar.getmembers():
                        member_path = os.path.join(path, member.name)
                        if not is_within_directory(path, member_path):
                            raise Exception("Attempted Path Traversal in Tar File")
                
                    tar.extractall(path, members, numeric_owner=numeric_owner) 
                    
                
                safe_extract(tar)

            if INFO >= 3:
                print(os.listdir(Rep_Calc_ASTER))

            self.load_runs(Rep_Calc_ASTER)
        else:
            if INFO >= 3:
                print("Fichier inconnu.")


    def update_run_params(self, INFO, niter, Nom_Co_Mail_N, Nom_Co_Mail_NP1,
                          maillage_np1, maillage_np1_nom_med, Nom_Co_Mail_NP1_ANNEXE,
                          Rep_Calc_HOMARD_local, Rep_Calc_HOMARD_global, fic_homard_niterp1,
                          unite_fichier_homard_vers_aster, liste_champs):
        """Mise a jour de la liste des passages

        Arguments:
            niter : numero d'iteration de depart
            Nom_Co_Mail_N : Nom du concept du maillage n
            Nom_Co_Mail_NP1 : Nom du concept du maillage n+1
            maillage_np1 : concept ASTER du dernier maillage adapte
            maillage_np1_nom_med : Nom MED du dernier maillage adapte
            Nom_Co_Mail_NP1_ANNEXE : Nom du concept du maillage n+1 annexe
            Rep_Calc_HOMARD_local : répertoire local de calcul de HOMARD
            Rep_Calc_HOMARD_global : répertoire global de calcul de HOMARD
            fic_homard_niterp1 : fichier HOMARD n+1
            unite_fichier_homard_vers_aster : unite du fichier d'ASTER vers HOMARD
            liste_champs : liste des champs definis
        """
        if INFO >= 3:
            print("Dans update_run_params, numero d'iteration", niter)

        # A.1. Une nouvelle iteration
        #      On emet une alarme si il existe deja un cas pour etre certain
        #      que l'utilisateur ne s'est pas trompe dans l'enchainement
        #
        if niter == 0:
        #
        # A.1.1. On stocke tous les cas deja enregistres
        #        On emet une alarme si il existe deja un cas pour etre certain
        #        que l'utilisateur ne s'est pas trompe dans l'enchainement
            for dico in self._run_params:
                UTMESS("A", 'HOMARD0_9', valk=(Nom_Co_Mail_N, Nom_Co_Mail_NP1,
                    dico["Maillage_NP1"], dico["Maillage_0"]), vali=dico["niter"] + 1)

            dico = {}
            dico["Maillage_0"] = Nom_Co_Mail_N
            dico["Maillage_NP1"] = Nom_Co_Mail_NP1
            assert Nom_Co_Mail_NP1 == maillage_np1.getName()
            self.store_object(maillage_np1) #XXX
            dico["maillage_np1_nom_med"] = maillage_np1_nom_med
            dico["Maillage_NP1_ANNEXE"] = Nom_Co_Mail_NP1_ANNEXE
            dico["Rep_Calc_HOMARD_local"] = Rep_Calc_HOMARD_local
            dico["Rep_Calc_HOMARD_global"] = Rep_Calc_HOMARD_global
            dico["niter"] = niter
            dico["fic_homard_niterp1"] = fic_homard_niterp1
            dico["unite_fichier_homard_vers_aster"] = unite_fichier_homard_vers_aster
            dico["liste_champs"] = self.store_fields_data(liste_champs) #XXX
            self._run_params.append(dico)
            if INFO >= 3:
                print(".. Nouveau dico", dico)
        #
        # A.2. Modification du cas en cours
        #
        else:
            for dico in self._run_params:
                if dico["Maillage_NP1"] == Nom_Co_Mail_N:
                    dico["Maillage_NP1"] = Nom_Co_Mail_NP1
                    assert Nom_Co_Mail_NP1 == maillage_np1.getName()
                    self.store_object(maillage_np1) #XXX
                    dico["maillage_np1_nom_med"] = maillage_np1_nom_med
                    dico["Maillage_NP1_ANNEXE"] = Nom_Co_Mail_NP1_ANNEXE
                    dico["niter"] = niter
                    dico["fic_homard_niterp1"] = fic_homard_niterp1
                    dico["unite_fichier_homard_vers_aster"] = unite_fichier_homard_vers_aster
                    dico["liste_champs"] = self.store_fields_data(liste_champs) #XXX
                    if INFO >= 3:
                        print(".. Nouveau dico", dico)


def argument_maillage(INFO, args, mot_cle, mode_homard):
#
    """
  Les maillages dans les arguments
  Entree :
    INFO : niveau d'information pour la macro-commande
    args : dictionnaire des arguments de macr_adap_mail
    mot_cle : mot-cle a examiner
    mode_homard : mode de homard (MODI, LECT, ADAP)
  Sortie :
    dico : dictionnaire pour ce maillage (cf. 3)
    """
#
    if INFO >= 3:
        print("\nDans argument_maillage, mode_homard =", mode_homard)
        print("Dans argument_maillage, mot_cle     =", mot_cle)
#
    dico = {}
    dico["Type_Maillage"] = mot_cle
    dico["Action"] = "Rien"
#
    if (mot_cle in args):
        if args.get(mot_cle) is not None:
        # print "==> args.get(",mot_cle,"] =",args.get(mot_cle]
            dico["Nom_ASTER"] = args.get(mot_cle)
            if (mode_homard in ("MODI", "ADAP")):
                if (mot_cle == "MAILLAGE_N"):
                    dico["Action"] = "A_ecrire"
                else:
                    dico["Action"] = "A_lire"
            else:
                dico["Action"] = "mot_cle"
#
    if INFO >= 3:
        print("dico =", dico)
#
    return dico
#
# ======================================================================
#


def argument_pilotage(INFO, args):
#
    """
  Le pilotage dans les arguments
  Entree :
    INFO : niveau d'information pour la macro-commande
    args : dictionnaire des arguments de macr_adap_mail
  Sortie :
    dico : dictionnaire du pilotage (cf. 4)
    """
#
    # nom_fonction = __name__ + "/argument_pilotage"
    # print "\nDans " + nom_fonction
    dico = {}
#
    dico["Usage_champ"] = "INDICATEUR"
    if (args.get("RESULTAT_N") is not None):
        dico["RESULTAT"] = args.get("RESULTAT_N")
        dico["NOM_CHAM"] = args.get("NOM_CHAM")
        if (args.get("NUME_ORDRE") is not None):
            dico["NUME_ORDRE"] = args.get("NUME_ORDRE")
        if (args.get("INST") is not None):
            dico["INST"] = args.get("INST")
            for cle in ["PRECISION", "CRITERE"]:
                if (args.get(cle) is not None):
                    dico[cle] = args.get(cle)
    else:
        dico["CHAM_GD"] = args.get("CHAM_GD")
    # print "dico =", dico
#
    nom_cham_med_fichier = "champ_de_pilotage"
#                         12345678901234567890123456789012
    dico["NOM_CHAM_MED"] = nom_cham_med_fichier
    # print "==> dico[\"NOM_CHAM_MED\"] =", dico["NOM_CHAM_MED"]
#
    if "NOM_CMP" in args:
        if args.get("NOM_CMP") is not None:
            if not type(args.get("NOM_CMP")) in EnumTypes:
                l_aux = [args.get("NOM_CMP")]
            else:
                l_aux = []
                les_composantes = args.get("NOM_CMP")
                for composante in les_composantes:
                    l_aux.append(composante)
            dico["COMPOSANTE"] = l_aux
#
    if INFO >= 3:
        print("dico =", dico)
#
    return dico
#
# ======================================================================
#


def argument_champ(INFO, le_champ, usage_champ, iaux):
#
    """
  Les champs dans les arguments
  Entree :
    INFO : niveau d'information pour la macro-commande
    le_champ : nom du champ a traiter
    usage_champ : usage du champ a traiter : "MAJ_CHAM" ou "ADD_CHAM"
    iaux : numero du champ precedement retenu
  Sortie :
    dico : dictionnaire du pilotage (cf. 4)
    iaux : numero du champ effectivement retenu
    """
#
    if INFO >= 3:
        print("\nDans argument_champ, le_champ =", le_champ)
        print("Dans argument_champ, usage_champ =", usage_champ)
        print("Dans argument_champ, iaux =", iaux)
#
    dico_interp = {}
    dico_interp["AUTO"] = 0
    dico_interp["ISOP2"] = 3
#
# A.1 Cles obligatoires
#
    dico = {}
    dico["Usage_champ"] = usage_champ
    if (usage_champ == "MAJ_CHAM"):
        l_aux = ["CHAM_MAJ"]
    else:
        l_aux = ["CHAM_GD", "CHAM_CAT"]
#
# A.2 Definition du champ a mettre a jour
#
    if (usage_champ == "MAJ_CHAM"):
        if (le_champ["RESULTAT"] is not None):
            l_aux.append("RESULTAT")
            l_aux.append("NOM_CHAM")
            if (le_champ["NUME_ORDRE"] is not None):
                dico["NUME_ORDRE"] = le_champ["NUME_ORDRE"]
            elif (le_champ["INST"] is not None):
                dico["INST"] = le_champ["INST"]
                for cle in ["PRECISION", "CRITERE"]:
                    if (le_champ[cle] is not None):
                        dico[cle] = le_champ[cle]
        else:
            l_aux.append("CHAM_GD")
#
# A.3 Archivage dans le dictionnaire decrivant le champ
#
    for cle in l_aux:
        dico[cle] = le_champ[cle]
        # print "dico =", dico
#
# A.4 Le type de champ
#
    if (usage_champ == "MAJ_CHAM"):
        type_cham = le_champ["TYPE_CHAM"]
    else:
        type_cham = "CART_NEUT_R"
    dico["TYPE_CHAM"] = type_cham
#
# A.5 Ajout des eventuels noms de composantes
#
    if (usage_champ == "MAJ_CHAM"):
        if le_champ["NOM_CMP"] is not None:
            if not type(le_champ["NOM_CMP"]) in EnumTypes:
                l_aux = [le_champ["NOM_CMP"]]
            else:
                l_aux = []
                les_composantes = le_champ["NOM_CMP"]
                for composante in les_composantes:
                    l_aux.append(composante)
            dico["COMPOSANTE"] = l_aux
            # print "COMPOSANTE", dico["COMPOSANTE"]
#
# A.6 Le type de mise a jour
#
    if (usage_champ == "MAJ_CHAM"):
        dico["TYPE_MAJ"] = dico_interp[le_champ["TYPE_MAJ"]]
            # print "==> dico[\"TYPE_MAJ\"] =", dico["TYPE_MAJ"]
#
# A.7 Le nom MED du champ
#
    iaux += 1
    la_chaine = '%08d' % iaux
    nom_cham_med_fichier = "champ_" + la_chaine
#                               123456789012345678901234    56789012
    dico["NOM_CHAM_MED"] = nom_cham_med_fichier
        # print "==> dico[\"NOM_CHAM_MED\"] =", dico["NOM_CHAM_MED"]
#
    if INFO >= 3:
        print("dico =", dico)
#
    return dico, iaux
#
# ======================================================================
#


def argument_zone(INFO, args):
#
    """
  Les zones dans les arguments
  Entree :
    INFO : niveau d'information pour la macro-commande
    args : dictionnaire des arguments de macr_adap_mail
  Sortie :
    liste_zones : liste des dictionnaires decrivant les zones (cf. 3)
    """
#
    l_aux = [
        'TYPE', 'USAGE', 'X_MINI', 'X_MAXI', 'Y_MINI', 'Y_MAXI', 'Z_MINI', 'Z_MAXI', 'X_CENTRE', 'Y_CENTRE',
        'Z_CENTRE', 'RAYON', 'RAYON_INT', 'RAYON_EXT', 'X_AXE', 'Y_AXE', 'Z_AXE', 'X_BASE', 'Y_BASE', 'Z_BASE', 'HAUTEUR']
#
    liste_zones = []
    les_zones = args.get("ZONE")
#
    for zone in les_zones:
        # print zone, "de type", type(zone)
        dico = {}
        for aux in l_aux:
            if (zone[aux] is not None):
                dico[aux] = zone[aux]
        # print dico
        liste_zones.append(dico)
        if INFO >= 3:
            print("dico =", dico)
#
    return liste_zones
#
# ======================================================================
#


def argument_frontiere_analytique(INFO, args):
#
    """
  Les frontieres analytiques dans les arguments
  Entree :
    INFO : niveau d'information pour la macro-commande
    args : dictionnaire des arguments de macr_adap_mail
  Sortie :
    liste_front_analytiques : liste des dictionnaires decrivant les frontieres analytiques (cf. 3)
    """
#
    liste_front_analytiques = []
    les_front_analytiques = args.get("FRONTIERE_ANALYTIQUE")
#
    for frontiere in les_front_analytiques:
        l_aux = ["NOM", "TYPE", "GROUP_MA", "X_CENTRE", "Y_CENTRE", "Z_CENTRE"]
        if (frontiere["TYPE"] in ("CYLINDRE", "CONE_A", "TORE")):
            l_aux.append("X_AXE")
            l_aux.append("Y_AXE")
            l_aux.append("Z_AXE")
        if (frontiere["TYPE"] in ("CYLINDRE", "SPHERE")):
            l_aux.append("RAYON")
        if (frontiere["TYPE"] in ("CONE_R", "TORE")):
            l_aux.append("RAYON")
            l_aux.append("RAYON2")
        if (frontiere["TYPE"] == "CONE_A"):
            l_aux.append("ANGLE")
        if (frontiere["TYPE"] == "CONE_R"):
            l_aux.append("X_CENTRE2")
            l_aux.append("Y_CENTRE2")
            l_aux.append("Z_CENTRE2")
        dico = {}
        for aux in l_aux:
            dico[aux] = frontiere[aux]
        if INFO >= 3:
            print("dico =", dico)
        liste_front_analytiques.append(dico)
#
    return liste_front_analytiques


def version_homard_aster(INFO, VERSION_HOMARD):
#
    """
  Mise en forme de la version de homard
  Remarque : dans la donnee de la version de HOMARD, il faut remplacer le _ de la donnee
             par un ., qui est interdit dans la syntaxe du langage de commandes ASTER
  Remarque : il faut remplacer le N majuscule de la donnee par un n minuscule,
             qui est interdit dans la syntaxe du langage de commandes ASTER
  Entree :
    INFO : niveau d'information pour la macro-commande
    VERSION_HOMARD : la valeur donnee au mot-cle de la version
  Sortie :
    VERSION_HOMARD : la version de homard mise en forme
    version_perso : vrai/faux si la version est la version personnelle
    """
#
    VERSION_HOMARD = VERSION_HOMARD.replace("_", ".")
    VERSION_HOMARD = VERSION_HOMARD.replace("N", "n")
#
    if (VERSION_HOMARD[-6:] == ".PERSO"):
        VERSION_HOMARD = VERSION_HOMARD[:-6]
        version_perso = 1
    else:
        version_perso = 0
        # print ".... VERSION_HOMARD =", VERSION_HOMARD
        # print ".... version_perso  =", version_perso
#
    return VERSION_HOMARD, version_perso
#
# ======================================================================
#


def fichier_echange_unite(INFO, numero_passage_fonction):
#
    """
  Les unites des fichiers d'echange entre Aster et HOMARD
  Remarque : aujourd'hui, les ecritures ou les lectures au format MED se font obligatoirement
             dans un fichier de nom fort.n, place dans le répertoire de calcul
  Entree :
    INFO : niveau d'information pour la macro-commande
    numero_passage_fonction : numero du passage dans cette macro
  Sortie :
    unite_fichier_aster_vers_homard : unite du fichier d'ASTER vers HOMARD
    unite_fichier_homard_vers_aster : unite du fichier d'ASTER vers HOMARD
    """
#
    if INFO >= 3:
        print("\nDans fichier_echange_unite, numero_passage_fonction =", numero_passage_fonction)
#
# A.1. ==> D'ASTER vers HOMARD
#
    unite_fichier_aster_vers_homard = 1787 + 2 * numero_passage_fonction
    # print "unite_fichier_aster_vers_homard =",unite_fichier_aster_vers_homard
#
# A.2. ==> De HOMARD vers ASTER
#
    unite_fichier_homard_vers_aster = unite_fichier_aster_vers_homard + 1
    # print "unite_fichier_homard_vers_aster =",unite_fichier_homard_vers_aster
#
    return unite_fichier_aster_vers_homard, unite_fichier_homard_vers_aster
#
#
# ======================================================================
#


def fichier_echange_nom(INFO, unite, Rep_Calc_ASTER):
#
    """
  Les noms des fichiers d'echange entre Aster et HOMARD
  Remarque : aujourd'hui, les ecritures ou les lectures au format MED se font obligatoirement
             dans un fichier de nom fort.n, place dans le répertoire de calcul
  Entree :
    INFO : niveau d'information pour la macro-commande
    unite : unite du fichier voulu
    Rep_Calc_ASTER : répertoire de calcul d'Aster
  Sortie :
    fichier : nom du fichier associe a l'unite
    """
#
    if INFO >= 3:
        print("\nDans fichier_echange_nom, unite =", unite)
#
    saux = "fort.%d" % unite
    fichier = os.path.join(Rep_Calc_ASTER, saux)
    # print "fichier =",fichier
#
    return fichier
#
# ======================================================================
#


def champ_imprime_0(INFO, dico_pilo, liste_champs):
#
    """
  Recherche d'un doublon eventuel sur le champ de pilotage de l'adaptation
  Entree :
    INFO : niveau d'information pour la macro-commande
    dico_pilo : dictionnaire du champ de pilotage
    liste_champs : liste des champs definis
  Sortie :
    liste_champs_imprime : liste des champs imprimes
    """
#
    if INFO >= 3:
        print("\nDans champ_imprime_0, dico_pilo =", dico_pilo)
#
# A.1. Le champ de pilotage est-il deja imprime ?
#
    if len(dico_pilo) > 0:
        chp_pilo_est_deja_imprime = 0
        if "RESULTAT" in dico_pilo:
            l_aux = ["RESULTAT", "NOM_CHAM"]
        else:
            l_aux = ["CHAM_GD"]
    else:
        chp_pilo_est_deja_imprime = 1
        l_aux = []
#
    if INFO >= 3:
        print("\nchp_pilo_est_deja_imprime =", chp_pilo_est_deja_imprime)
#
# A.2. Parcours des champs definis
#
    liste_champs_imprime = []
#
    for dico in liste_champs:
#
# A.2.1. Pour un champ a mettre a jour, on a toujours impression
#
        # print "\n.... dico =", dico
        if (dico["Usage_champ"] == "MAJ_CHAM"):
#
            liste_champs_imprime.append(dico)
# Si le champ de pilotage de l'adaptation n'a toujours pas ete repere
# comme champ a mettre a jour :
            if not chp_pilo_est_deja_imprime:
#       Est-ce le meme champ ?
                on_a_le_champ = 1
                for cle in l_aux:
                    if (cle in dico):
                        # print "...... dico_pilo[cle] =", dico_pilo[cle]
                        # print "...... dico[cle]      =", dico[cle]
                        if (dico_pilo[cle] != dico[cle]):
                            on_a_le_champ = 0
                            break
                    else:
                        on_a_le_champ = 0
                        break
#       Si oui, est-ce au meme moment ? (remarque : si rien n'est designe, c'est qu'il n'y a qu'un
#       seul instant ... donc c'est le meme ! En revanche, on ne sait pas comparer une donnee
#       en numero d'ordre et une donnee en instant. On croise les doigts.)
                if on_a_le_champ:
                    for cle in ["NUME_ORDRE", "INST"]:
                        if cle in dico:
                            if (dico[cle] is not None):
                                if cle in dico_pilo:
                                    if (dico_pilo[cle] != dico[cle]):
                                        on_a_le_champ = 0
                                        break
#       Le champ de pilotage fait partie des champs mis a jour : on le note
#       et on utilise le meme nom de champ MED
                if on_a_le_champ:
                    dico_pilo["NOM_CHAM_MED"] = dico["NOM_CHAM_MED"]
                    chp_pilo_est_deja_imprime = 1
#
    if INFO >= 3:
        print("\nFin de la boucle .. chp_pilo_est_deja_imprime =", chp_pilo_est_deja_imprime)
#
# A.3. Si le champ de pilotage de l'adaptation n'a pas ete repere comme champ a mettre a jour,
#      il faut l'inclure dans les champs a imprimer
#
    if not chp_pilo_est_deja_imprime:
        liste_champs_imprime.append(dico_pilo)
#
    return liste_champs_imprime
#
# ======================================================================
#


def cree_configuration(INFO, args, Rep_Calc_ASTER, mode_homard, VERSION_HOMARD, version_perso, Rep_Calc_HOMARD_global, niter, fichier_aster_vers_homard, fichier_homard_vers_aster, liste_maillages, liste_champs, liste_zones, liste_front_analytiques):
#
    """
  Creation des donnees pour le fichier de configuration de HOMARD
  Entree :
    INFO : niveau d'information pour la macro-commande
    args : dictionnaire des arguments de macr_adap_mail
    Rep_Calc_ASTER : répertoire de calcul d'Aster
    mode_homard : mode de homard (MODI, INFO, ADAP, LECT)
    VERSION_HOMARD : la version de homard mise en forme
    version_perso : vrai/faux si la version est la version personnelle
    Rep_Calc_HOMARD_global : répertoire global de calcul de HOMARD
    niter : numero d'iteration de depart
    fichier_aster_vers_homard : fichier d'ASTER vers HOMARD
    fichier_homard_vers_aster : fichier de HOMARD vers ASTER
    liste_maillages : liste des maillages definis
    liste_champs : liste des champs definis
    liste_zones : liste des dictionnaires decrivant les zones (cf. 3)
    liste_front_analytiques : liste des dictionnaires decrivant les frontieres analytiques (cf. 3)
  Sortie :
    dico_configuration : dictionnaire decrivant le fichier de configuration de HOMARD
    """
#
    if INFO >= 3:
        print("\nPassage dans cree_configuration")
#
    dico_configuration = {}
#
# A.1. ==> Les generalites
#
    dico_configuration["INFO"] = INFO
#
    dico_configuration["Rep_Calc_HOMARD_global"] = Rep_Calc_HOMARD_global
    dico_configuration["VERSION_HOMARD"] = VERSION_HOMARD
    dico_configuration["version_perso"] = version_perso
    if "UNITE" in args:
        UNITE = args.get("UNITE")
        if (UNITE is not None):
            saux = "fort.%d" % UNITE
            fichier_conf_suppl = os.path.join(Rep_Calc_ASTER, saux)
            dico_configuration["fichier_conf_suppl"] = fichier_conf_suppl
#
    dico_configuration["niter"] = niter
    dico_configuration["Fichier_ASTER_vers_HOMARD"] = fichier_aster_vers_homard
    if (mode_homard in ["ADAP", "MODI"]):
        dico_configuration[
            "Fichier_HOMARD_vers_ASTER"] = fichier_homard_vers_aster
#
# A.2. ==> Les noms med des maillages
#
    for dico in liste_maillages:
            # print "Nom MED de " + dico["Type_Maillage"] + " = " +
            # dico["NOM_MED"]
        dico_configuration[
            "NOM_MED_" + dico["Type_Maillage"]] = dico["NOM_MED"]
        # print dico_configuration
#
# A.3. ==> Les caracteristiques de l'eventuel pilotage de l'adaptation
#
    for dico in liste_champs:
        dico_aux = {}
        if (dico["Usage_champ"] == "INDICATEUR"):
            l_aux = []
            if "NOM_CHAM_MED" in dico:
                l_aux.append("NOM_CHAM_MED")
            if "COMPOSANTE" in dico:
                l_aux.append("COMPOSANTE")
            if "NUME_ORDRE" in dico:
                l_aux.append("NUME_ORDRE")
            for cle in l_aux:
                if (dico[cle] is not None):
                    dico_aux[cle] = dico[cle]
            dico_configuration["Indicateur"] = dico_aux
#    if dico_configuration.has_key("Indicateur") :
            # print "dico_configuration[Indicateur] =", dico_configuration["Indicateur"]
#
# A.4. ==> Les eventuelles zones de raffinement
#
    prem = 1
    for dico in liste_zones:
        if prem:
            l_aux = [dico]
            prem = 0
        else:
            l_aux = dico_configuration["Zones_raffinement"]
            l_aux.append(dico)
        dico_configuration["Zones_raffinement"] = l_aux
    # if dico_configuration.has_key("Zones_raffinement") :
        # print "dico_configuration[Zones_raffinement] =", dico_configuration["Zones_raffinement"]
#
# A.5. ==> Les eventuelles mises a jour de champs
#
    prem = 1
    for dico in liste_champs:
        # print "prem =", prem
        # print dico
        if (dico["Usage_champ"] == "MAJ_CHAM"):
            dico_aux = {}
            l_aux = ["NOM_CHAM_MED", "COMPOSANTE", "TYPE_MAJ"]
            if "NUME_ORDRE" in dico:
                l_aux.append("NUME_ORDRE")
            else:
                for cle in ["RESULTAT", "NOM_CHAM", "INST", "PRECISION", "CRITERE"]:
                    l_aux.append(cle)
            for cle in l_aux:
                if cle in dico:
                    if (dico[cle] is not None):
                        dico_aux[cle] = dico[cle]
            # print dico_aux
            if prem:
                l_aux = [dico_aux]
                prem = 0
            else:
                l_aux = dico_configuration["Champs_mis_a_jour"]
                l_aux.append(dico_aux)
            dico_configuration["Champs_mis_a_jour"] = l_aux
        # if dico_configuration.has_key("Champs_mis_a_jour") :
            # print "dico_configuration[Champs_mis_a_jour] =", dico_configuration["Champs_mis_a_jour"]
#
# A.6. ==> Les eventuels champs supplementaires
#
    prem = 1
    for dico in liste_champs:
        if (dico["Usage_champ"] == "ADD_CHAM"):
            dico_aux = {}
            l_aux = ["NOM_CHAM_MED", "CHAM_CAT"]
            for cle in l_aux:
                dico_aux[cle] = dico[cle]
            # print dico_aux
            if prem:
                l_aux = [dico_aux]
                prem = 0
            else:
                l_aux = dico_configuration["Champs_supplementaires"]
                l_aux.append(dico_aux)
            dico_configuration["Champs_supplementaires"] = l_aux
    if INFO >= 3:
        if "Champs_supplementaires" in dico_configuration:
            print("dico_configuration[Champs_supplementaires] =", dico_configuration["Champs_supplementaires"])
#
# A.7. ==> Les eventuelles frontieres analytiques
#
    prem = 1
    for dico in liste_front_analytiques:
        if prem:
            l_aux = [dico]
            prem = 0
        else:
            l_aux = dico_configuration["Frontiere_analytique"]
            l_aux.append(dico)
        dico_configuration["Frontiere_analytique"] = l_aux
        # if dico_configuration.has_key("Frontiere_analytique") :
            # print "dico_configuration[Frontiere_analytique] =", dico_configuration["Frontiere_analytique"]
#
    return dico_configuration
#
# ======================================================================
#


def file_print(Rep_Calc_HOMARD_global):
#
    """
  Impression des fichiers des donnees pour HOMARD
  Entree :
    Rep_Calc_HOMARD_global : répertoire global de calcul de HOMARD
  Sortie :
    """
#
    l_aux = ["HOMARD.Donnees", "HOMARD.Configuration"]
#
    for nomfic in l_aux:
#
        fic = os.path.join(Rep_Calc_HOMARD_global, nomfic)
        if os.path.isfile(fic):
            print("\n\n==============================================================")
            print("Contenu de", nomfic)
            fichier = open(fic, "r")
            les_lignes = fichier.readlines()
            fichier.close()
            for ligne in les_lignes:
                print(ligne[:-1])
            print("==============================================================\n")
#
    return
#
# ======================================================================
#


def file_remove(INFO, mode_homard, Rep_Calc_HOMARD_global, fichier_aster_vers_homard, fichier_homard_vers_aster, fic_homard_niterp1, garder_fic_homard_aster):
#
    """
  Liste des fichiers devenus inutiles
  Il est important de faire le menage des fichiers MED, qui sont les plus gros.
  En mode adaptation, on doit imperativement garder le dernier fichier homard produit
  En mode d'information, on garde egalement les fichiers textes
  Entree :
    INFO : niveau d'information pour la macro-commande
    mode_homard : mode de homard (MODI, INFO, ADAP, LECT)
    Rep_Calc_HOMARD_global : répertoire global de calcul de HOMARD
    fichier_aster_vers_homard : fichier d'ASTER vers HOMARD
    fichier_homard_vers_aster : fichier de HOMARD vers ASTER
    fic_homard_niterp1 : fichier HOMARD a l'iteration n+1
    garder_fic_homard_aster : 0/1 pour l'existence de champ ELNO ou ELGA
  Sortie :
    l_aux : liste des fichiers a supprimer
    """
#
    l_aux = []
#
    if (mode_homard != "LECT"):
        l_aux.append(fichier_aster_vers_homard)
#
    if (mode_homard in ["ADAP", "MODI"]):
        if not garder_fic_homard_aster:
            l_aux.append(fichier_homard_vers_aster)
#
    l_aux_bis = os.listdir(Rep_Calc_HOMARD_global)
    for fic in l_aux_bis:
        fic_total = os.path.join(Rep_Calc_HOMARD_global, fic)
        l_aux.append(fic_total)
#
    if (mode_homard in ("ADAP", "LECT")):
        fic = os.path.join(Rep_Calc_HOMARD_global, fic_homard_niterp1)
        l_aux.remove(fic)
#
    if INFO >= 3:
        print(".. Liste des fichiers a supprimer =", l_aux)
#
    return l_aux
#
# ======================================================================


def int_to_str2(entier):
    """
  Transforme un entier positif en une chaine d'au moins deux caracteres :
  0 devient '00', 4 devient '04', 12 devient '12', 589 devient '589', ...
  Entree :
    entier : l'entier a transformer
  Sortie :
    la_chaine : la chaine
    """
    # print "\nArguments à l'entree de", __name__, ":", entier
#
    if type(entier) == type(0):
        la_chaine = '%02d' % entier
    else:
        la_chaine = None
#
    return la_chaine
#
# ======================================================================
#


def post_traitement(INFO, mode_homard, dico_configuration, Rep_Calc_ASTER):
#
    """
  Operations eventuelles en post-traitement de l'adaptation
  Entree :
    INFO : niveau d'information pour la macro-commande
    mode_homard : mode de homard (MODI, INFO, ADAP, LECT)
    dico_configuration : dictionnaire decrivant le fichier de configuration de HOMARD
                         voir la fonction 'cree_configuration'
    Rep_Calc_ASTER : répertoire de calcul d'Aster
  Sortie :
    d_aux : dictionnaire avec une cle obligatoire :
            erreur : 0, si OK, !=0 si probleme
    """
#
    if INFO >= 3:
        print("\nPassage dans post_traitement")
#
    d_aux = {}
    erreur = 0
#
    while not erreur:
#
# 1. Recuperation d'informations dans la configuration
#
        # print dico_configuration
#
        niter = dico_configuration["niter"]
        Rep_Calc_HOMARD_global = dico_configuration["Rep_Calc_HOMARD_global"]
        fichier_aster_vers_homard = dico_configuration[
            "Fichier_ASTER_vers_HOMARD"]
        if (mode_homard in ["ADAP", "MODI"]):
            fichier_homard_vers_aster = dico_configuration[
                "Fichier_HOMARD_vers_ASTER"]
#
        str_niter = int_to_str2(niter)
        str_niterp1 = int_to_str2(niter + 1)
        str_niter_vers_niterp1 = str_niter + ".vers." + str_niterp1
#    print "str_niter_vers_niterp1", str_niter_vers_niterp1
#
# 2. Copie des fichiers bruts d'indicateurs
#    On doit personnaliser le répertoire d'arrivee
#
        # HOME = os.environ["HOME"]
        # reparr = os.path.join(HOME, "ASTER_USER", "TEST", "zzzz175b", "Indic")
        # reparr = Rep_Calc_ASTER
        # if os.path.isdir(reparr) :
            # l_aux = [ "no", "ar", "tr", "qu", "te", "he", "pe", "py" ]
            # for suff in l_aux :
                # nomfic = "ind." + suff + ".%03d.dat" % niter
                # ficdeb = os.path.join(Rep_Calc_HOMARD_global, nomfic)
                # if os.path.isfile(ficdeb) :
                    # ficarr = os.path.join(reparr, nomfic)
                    # if ( INFO >= 3 ) :
                        # print "\nCopie de", ficdeb, "dans", ficarr
                    # shutil.copyfile(ficdeb, ficarr)
                # else :
                    # if ( INFO >= 3 ) :
                        # print "\nLe fichier", ficdeb, "est inconnu."
        # else :
            # if ( INFO >= 2 ) :
                # print "Le répertoire", reparr, "est inconnu."
            # erreur = 2
            # break
#
# 3. Analyse de la liste standard
#
        if INFO >= 3:
            if (mode_homard in ["ADAP", "MODI"]):
                nomfic = "Liste." + str_niter_vers_niterp1
                fic = os.path.join(Rep_Calc_HOMARD_global, nomfic)
                if os.path.isfile(fic):
                    print("\nAnalyse de", fic)
                    fichier = open(fic, "r")
                    les_lignes = fichier.readlines()
                    fichier.close()
                    for ligne in les_lignes:
                        print(ligne[:-1])
#
        break
#
#
    d_aux["erreur"] = erreur
#
    return d_aux
#
# ======================================================================
#

ginfos = HomardInfo()


def macr_adap_mail_ops(self,
                       INFO, VERSION_HOMARD, LOGICIEL=None, MAILLAGE_FRONTIERE=None,
                       **args):
    """
       Traitement des macros MACR_ADAP_MAIL/MACR_INFO_MAIL

    1. args est le dictionnaire des arguments
       args.keys() est la liste des mots-cles
       args.keys()[0] est la premiere valeur de cette liste
       args.keys()[1:] est la liste des valeurs suivantes dans cette liste
       args.keys(mot_cle) represente le contenu de la variable mot_cle dans la macro appelante.

    2. Les caracteristiques d'un passage sont conservees dans un dictionnaire. Il y a autant de
       dictionnaires que de sollicitations pour une serie d'adaptation. L'ensemble de ces dictionnaires
       est conserve dans la liste `run_params`. Cette liste est necessairement globale pour pouvoir
       la retrouver a chaque nouveau passage.
       Description du dictionnaire de passages :
          dico["Maillage_0"]             = o ; string ; nom du concept du maillage initial de la serie d'adaptation
          dico["Maillage_NP1"]           = o ; string ; nom du concept du dernier maillage adapte
          dico["maillage_np1"]           = o ; concept ASTER du dernier maillage adapte
          dico["maillage_np1_nom_med"]   = o ; string ; Nom MED du dernier maillage adapte
          dico["Rep_Calc_HOMARD_global"] = o ; string ; Nom global du répertoire de calcul pour HOMARD
          dico["Rep_Calc_HOMARD_local"]  = o ; string ; Nom local du répertoire de calcul pour HOMARD
                                                        depuis le répertoire de calcul pour ASTER
          dico["niter"]                  = o ; entier ; numero d'iteration de depart
          dico["fichier_homard_vers_aster"] = f ; string ; nom du fichier d'echange entre HOMARD et Aster
          dico["fic_homard_niterp1"]     = o ; string ; nom du fichier HOMARD a l'iteration n+1
          dico["liste_champs"]           = o ; string ; liste des champs

    3. Les caracteristiques d'un maillage sont conservees dans un dictionnaire. Il y a autant de
       dictionnaires que de maillages manipules. L'ensemble de ces dictionnaires est conserve
       dans la liste liste_maillages.
       Description du dictionnaire de maillages :
          dico["Type_Maillage"] = o ; string ; "MAILLAGE_N", "MAILLAGE_NP1", "MAILLAGE_NP1_ANNEXE" ou "MAILLAGE_FRONTIERE"
          dico["Nom_ASTER"]     = o ; concept ASTER associe
          dico["Action"]        = o ; string ; "A_ecrire" ou "A_lire"
          dico["NOM_MED"]       = o ; string ; Nom MED du maillage

    4. Les caracteristiques d'un champ sont conservees dans un dictionnaire. Il y a autant de
       dictionnaires que de champs manipules. L'ensemble de ces dictionnaires est conserve
       dans la liste liste_champs.
       Description du dictionnaire de champs :
          dico["Usage_champ"]  = o ; string ; "INDICATEUR" ou "MAJ_CHAM" ou "ADD_CHAM"
          dico["RESULTAT"]     = f ; concept ASTER du resutat associe
          dico["NOM_CHAM"]     = f ; string ; Nom ASTER du champ
          dico["CHAM_GD"]      = f ; concept ASTER du champ de grandeur associee
          dico["COMPOSANTE"]   = f ; liste ; Liste des noms ASTER des composantes du champ
          dico["NUME_ORDRE"]   = f ; entier ; Numero d'ordre du champ
          dico["INST"]         = f ; entier ; Instant du champ
          dico["PRECISION"]    = f ; entier ; Precision sur l'instant du champ
          dico["CRITERE"]      = f ; entier ; Critere de precision sur l'instant du champ
          dico["MAJ_CHAM"]     = f ; string ; Nom ASTER du champ interpole sur le nouveau maillage
          dico["NOM_CHAM_MED"] = o ; string ; Nom MED du champ
          dico["CHAM_CAT"]     = f ; string ; categorie du champ supplementaire

    5. Signification de INFO
       INFO = 1 : aucun message
       INFO = 2 : les messages des commandes annexes (DEFI_FICHIER, IMPR_RESU, LIRE_MAILLAGE, LIRE_CHAMP)
       INFO = 3 : aucun message pour les commandes annexes
                  1er niveau de message pour l'execution de HOMARD
       INFO = 4 : aucun message pour les commandes annexes
                  2nd niveau de message pour l'execution de HOMARD
    """
#
    # print 'glop'
    # print args
    # print args.keys()
    # if len (args.keys())>0 : print args.keys()[0]
    # print args.get("MAILLAGE")
#
#
#====================================================================
# 1. Prealables
#====================================================================
#
# 1.2. ==> Initialisations de parametres Aster
#
#
    Rep_Calc_ASTER = os.getcwd()
    if INFO >= 3:
        print("Contenu du répertoire de calcul d'Aster", Rep_Calc_ASTER)
        print(os.listdir(Rep_Calc_ASTER))
#
# 1.3. ==> Numéro du passage dans cette macro
#
    numero_passage_fonction = ginfos.new_run()
    if INFO >= 4:
        print("numero_passage_fonction =", numero_passage_fonction)
#
# 1.4. ==> Fichier d'archivage
#
# 1.4.2. ==> C'est le fichier contenu dans la base : son nom est pick.homard.tar (cf.11.2.1)
#
    fichier_archive = os.path.join(Rep_Calc_ASTER, "pick.homard.tar")
#
    fichier_archive = os.path.normpath(fichier_archive)
    if INFO >= 4:
        print("fichier_archive =", fichier_archive)
        # os.system("ls -la "+fichier_archive)
#
# 1.5. ==> Au tout premier passage, initialisation de la liste des passages
#
    if numero_passage_fonction == 1:
        ginfos.init_run_params(INFO, fichier_archive, Rep_Calc_ASTER)
#
    if INFO >= 3:
        print("1.4. run_params =", ginfos.run_params)
#
# 1.6. ==> Initialisations
#
    codret_partiel = [0]
#
    liste_maillages = []
    liste_champs = []
    liste_zones = []
    liste_front_analytiques = []
    dico_pilo = {}
#
    LISTE_ADAPTATION_LIBRE = ("RAFF_DERA", "RAFFINEMENT", "DERAFFINEMENT")
#
    if (INFO == 2):
        infomail = "OUI"
        infocomm = 2
    else:
        infomail = "NON"
        infocomm = 1
#
#====================================================================
# 2. Decodage des arguments de la macro-commande
#====================================================================
# 2.1. ==> Donnees de pilotage de l'adaptation
#
    if (self.command_name == "MACR_ADAP_MAIL"):
#
# 2.1.1. ==> Le mode d'utilisation de homard
#
        if args.get("ADAPTATION") == "MODIFICATION":
            mode_homard = "MODI"
        elif args.get("ADAPTATION") == "LECTURE":
            mode_homard = "LECT"
        else:
            mode_homard = "ADAP"
#
        if INFO >= 3:
            print("2.1.1. mode_homard =", mode_homard)
#
# 2.1.2. ==> Les concepts "maillage"
#
        # print "\n.. Debut de 2.1.2"
        for mot_cle in ["MAILLAGE_N", "MAILLAGE_NP1", "MAILLAGE_NP1_ANNEXE"]:
            dico = argument_maillage(INFO, args, mot_cle, mode_homard)
            liste_maillages.append(dico)
#
# 2.1.3. ==> L'eventuel pilotage de l'adaptation
#
        # print "\n.. Debut de 2.1.3"
        if args.get("ADAPTATION") in LISTE_ADAPTATION_LIBRE:
            dico = argument_pilotage(INFO, args)
            liste_champs.append(dico)
            dico_pilo = dico
            # print dico_pilo
#
# 2.1.4. ==> Les champs a mettre a jour ou supplementaires
        # print "\n.. Debut de 2.1.4."
#
        iaux = 0
        for usage_champ in ("MAJ_CHAM", "ADD_CHAM"):
#
            if usage_champ in args:
#
                if args.get(usage_champ) is not None:
                    les_champs = args.get(usage_champ)
                    for le_champ in les_champs:
                        dico, iaux = argument_champ(
                            INFO, le_champ, usage_champ, iaux)
                        liste_champs.append(dico)
#
# 2.1.5. ==> Les zones de raffinement
        # print "\n.. Debut de 2.1.5."
#
        if "ZONE" in args:
            if args.get("ZONE") is not None:
                liste_zones = argument_zone(INFO, args)
#
# 2.2. ==> Donnees de pilotage de l'information
#
    else:
#
        mode_homard = "INFO"
#
        dico = {}
        dico["Type_Maillage"] = "MAILLAGE_N"
        dico["Nom_ASTER"] = args.get("MAILLAGE")
        dico["Action"] = "A_ecrire"
        liste_maillages.append(dico)
#
# 2.3. ==> Suivi d'une frontiere
# 2.3.1. ==> Suivi d'une frontiere maillee
#
    # print "\n.. Debut de 2.3.1."
#
    if (MAILLAGE_FRONTIERE is not None):
#
        dico = {}
        dico["Type_Maillage"] = "MAILLAGE_FRONTIERE"
        dico["Nom_ASTER"] = MAILLAGE_FRONTIERE
        dico["Action"] = "A_ecrire"
        liste_maillages.append(dico)
#
# 2.3.2. ==> Suivi de frontieres analytiques
    # print "\n.. Debut de 2.3.2."
#
    if "FRONTIERE_ANALYTIQUE" in args:
        if args.get("FRONTIERE_ANALYTIQUE") is not None:
            liste_front_analytiques = argument_frontiere_analytique(
                INFO, args)
#
# 2.4. ==> Le numero de version de HOMARD
#    Remarque : dans la donnee de la version de HOMARD, il faut remplacer
#               le _ de la donnee par un ., qui est interdit dans la
#               syntaxe du langage de commandes ASTER
#    Remarque : il faut remplacer le N majuscule de la donnee par
#               un n minuscule, qui est interdit dans la syntaxe du langage
#               de commandes ASTER
#
    # print "\n.. Debut de 2.4. avec VERSION_HOMARD =", VERSION_HOMARD
    VERSION_HOMARD, version_perso = version_homard_aster(
        INFO, VERSION_HOMARD)
#
# 2.5. ==> Les messages d'information
#
    # print "\n.. Debut de 2.5."
    if "INTERPENETRATION" in args:
        if (args.get("INTERPENETRATION") == "OUI"):
            if (mode_homard == "INFO"):
                UTMESS('I', 'HOMARD0_6')
            else:
                UTMESS('A', 'HOMARD0_7')
#
# 2.6. ==> Noms des fichiers d'ASTER vers HOMARD et de HOMARD vers ASTER
#
    if (mode_homard != "LECT"):
        unite_fichier_aster_vers_homard, unite_fichier_homard_vers_aster = fichier_echange_unite(
            INFO, numero_passage_fonction)
        fichier_aster_vers_homard = fichier_echange_nom(
            INFO, unite_fichier_aster_vers_homard, Rep_Calc_ASTER)
        fichier_homard_vers_aster = fichier_echange_nom(
            INFO, unite_fichier_homard_vers_aster, Rep_Calc_ASTER)
#
#====================================================================
# 3. Preparation du lancement des commandes
#====================================================================
#
# 3.1. ==> . Elaboration des noms MED des concepts de maillage
#          . Memorisation des noms ASTER du maillage en entree et en sortie (sous forme string)
#
#          On cree une nouvelle liste des dictionnaires decrivant les maillages
#          et a la fin on ecrase l'ancienne liste par cette nouvelle.
#
    # print ".. Debut de 3.1."
#
    Nom_Co_Mail_NP1 = None
    Nom_Co_Mail_NP1_ANNEXE = None
    l_aux = []
    for dico in liste_maillages:
        # print ".... dico avant =", dico
        if (dico["Action"] != "Rien"):
            Nom_MED_Mail_NP1 = aster.mdnoma(dico["Nom_ASTER"].getName())
            dico["NOM_MED"] = Nom_MED_Mail_NP1
            l_aux.append(dico)
            if (dico["Type_Maillage"] == "MAILLAGE_N"):
                Nom_Co_Mail_N = dico["Nom_ASTER"].getName()
        # print ".... dico apres =", dico
    liste_maillages = l_aux
#
# 3.2. ==> Recherche du numero d'iteration et du répertoire de travail
#
# 3.2.1. ==> Par defaut :
#            . le numero d'iteration est nul
#            . le nom du répertoire de lancement de HOMARD est construit sur le nom
#              du maillage en entree et le numero de passage dans la fonction
#
    # print ".. Debut de 3.2.1."
    previous_mesh = args.get("IDENTIFICATION") or Nom_Co_Mail_N
#
    niter = 0
    saux = "_%d" % numero_passage_fonction
    Nom_Rep_local = Nom_Co_Mail_N + "_" + mode_homard + saux
    Rep_Calc_HOMARD_local = os.path.join(".", Nom_Rep_local)
    Rep_Calc_HOMARD_global = os.path.join(Rep_Calc_ASTER, Nom_Rep_local)
        # print "Rep_Calc_HOMARD_local  =", Rep_Calc_HOMARD_local
        # print "Rep_Calc_HOMARD_global =", Rep_Calc_HOMARD_global
#
# 3.2.2. ==> En adaptation ou en lecture, il faut repartir du répertoire de l'iteration precedente
#            On recherche si dans les passages deja effectues, il en existe un dont le maillage
#            d'arrivee etait l'actuel maillage d'entree. Si c'est le cas, cela veut dire que
#            l'adaptation en cours ou la lecture est la suite d'une precedente.
#            On doit donc utiliser le meme répertoire.
#            En adaptation, Le numero d'iteration est celui de l'adaptation precedente augmente de 1.
#
    # print ".. Debut de 3.2.2."
#
    if (mode_homard in ("ADAP", "LECT")):
#
        for dico in ginfos.run_params:
            # print ".... dico :", dico
#
            if dico["Maillage_NP1"] == previous_mesh:
#
                Rep_Calc_HOMARD_local = dico["Rep_Calc_HOMARD_local"]
                Rep_Calc_HOMARD_global = dico["Rep_Calc_HOMARD_global"]
                niter = dico["niter"]
                maillage_np1_nom_med = dico["maillage_np1_nom_med"]
                if (mode_homard == "ADAP"):
                    niter += 1
                fic_homard_niterp1 = dico["fic_homard_niterp1"]
#
                if (mode_homard == "LECT"):
                    maillage_n = ginfos.get_object(Nom_Co_Mail_N)
                    maillage_n_nom_med = maillage_np1_nom_med
                    unite_fichier_homard_vers_aster = dico["unite_fichier_homard_vers_aster"]
                    # liste_champs = dico["liste_champs"]
                    liste_champs = ginfos.get_fields_data(dico["liste_champs"])
#
                if INFO >= 3:
                    print(".... ==> répertoire de calcul de HOMARD :", Rep_Calc_HOMARD_local)
                    print(".... ==> niter :", niter)

                break
#
# 3.2.3. Le répertoire pour homard
#        Attention : on ne fait cette creation qu'une seule fois par cas
#                    d'adaptation, de modification ou d'information
#
    # print ".. Debut de 3.2.3. avec niter =", niter
#
    if (mode_homard != "LECT"):
#
        if (niter == 0):
#
            # Hmmm, the same mesh object but niter=0
            if os.path.isdir(Rep_Calc_HOMARD_global):
                UTMESS("A", 'HOMARD0_11',
                       valk=(Nom_Co_Mail_N, Rep_Calc_HOMARD_global))
                shutil.rmtree(Rep_Calc_HOMARD_global)
            try:
                os.mkdir(Rep_Calc_HOMARD_global)
            except os.error as codret_partiel:
                saux = "Code d'erreur de mkdir : %d" % codret_partiel[0]
                logger.warning(saux + " : " + codret_partiel[1])
                UTMESS("F", 'HOMARD0_4', valk=Rep_Calc_HOMARD_global)
#
        else:
#
            if not os.path.isdir(Rep_Calc_HOMARD_global):
                UTMESS("F", 'HOMARD0_8', valk=Rep_Calc_HOMARD_global)
            if INFO >= 3:
                print("Contenu du répertoire de calcul de HOMARD", Rep_Calc_HOMARD_local)
                print(os.listdir(Rep_Calc_HOMARD_global))
#
#====================================================================
# 4. Ecriture des commandes de creation des donnees MED
#====================================================================
#
    if (mode_homard != "LECT"):
#
#  On doit ecrire : le maillage,
#                   le champ de pilotage de l'adaptation
#                   les champs a convertir
#  Remarque : on met tout dans le meme fichier
#
#  Chacune de ces ecritures est optionnelle selon le contexte.
#
# 4.1. La definition du fichier de ASTER vers HOMARD
#
        # print ".. Debut de 4.1."
        DEFI_FICHIER(ACTION="ASSOCIER",
                     UNITE=unite_fichier_aster_vers_homard,
                     TYPE="LIBRE",
                     INFO=infocomm)
#
# 4.2. Le(s) maillage(s)
# Le maillage de calcul et l'eventuel maillage de la frontiere sont ecrits
# dans le meme fichier MED
# En fait, on pourrait s'en passer au dela de la 1ere iteration
# car HOMARD a memorise. Mais des que l'on ecrit un champ,
# les conventions MED imposent la presence du maillage dans le fichier.
# Donc on va toujours ecrire.
#
        # print ".. Debut de 4.2."
        for dico in liste_maillages:
            if (dico["Action"] == "A_ecrire"):
                motscsi = {}
                motscsi["MAILLAGE"] = dico["Nom_ASTER"]
                motscfa = {}
                motscfa["RESU"] = _F(INFO_MAILLAGE=infomail, **motscsi)
#
                IMPR_RESU(INFO=infocomm,
                          FORMAT='MED', UNITE=unite_fichier_aster_vers_homard, PROC0='NON',
                          **motscfa)
#
# 4.3. Le(s) champ(s)
#        Attention : il se peut que l'on demande la mise à jour du champ qui a servi comme
#                    pilotage de l'adaptation. Si c'est le cas, il ne faut pas demander son
#                    impression sinon il y a plantage d'IMPR_RESU qui ne sait pas substituer
#                    deux champs. D'ailleurs, c'est plus economique ainsi !
#        Remarque : pour l'adaptation ou les champs a mettre a jour, on peut ne demander
#                   qu'un nombre reduit de composantes.
#        dico["Usage_champ"]  = o ; string ; "INDICATEUR" ou "MAJ_CHAM" ou "ADD_CHAM"
#        dico["RESULTAT"]     = f ; concept ASTER du resutat associe
#        dico["NOM_CHAM"]     = f ; string ; Nom ASTER du champ
#        dico["CHAM_GD"]      = f ; concept ASTER du champ de grandeur associee
#        dico["COMPOSANTE"]   = f ; liste ; Liste des noms ASTER des composante du champ
#        dico["NUME_ORDRE"]   = f ; entier ; Numero d'ordre du champ
#        dico["INST"]         = f ; entier ; Instant du champ
#        dico["PRECISION"]    = f ; entier ; Precision sur l'instant du champ
#        dico["CRITERE"]      = f ; entier ; Critere de precision sur l'instant du champ
#        dico["MAJ_CHAM"]     = f ; string ; Nom ASTER du champ interpole sur le nouveau maillage
#        dico["NOM_CHAM_MED"] = o ; string ; Nom MED du champ
#        dico["CHAM_CAT"]     = f ; string ; categorie du champ supplementaire
#
# 4.3.1. Recherche d'un doublon eventuel sur le champ de pilotage de l'adaptation
        # print "\n.... Debut de 4.3.1."
#
        liste_champs_imprime = champ_imprime_0(INFO, dico_pilo, liste_champs)
#
# 4.3.2. Impressions apres le filtrage precedent
        # print "\n.... Debut de 4.3.2."
#
        for dico in liste_champs_imprime:
#
# 4.3.2.1. Caracteristiques
#
            motscsi = {}
            for cle in ["RESULTAT", "NOM_CHAM", "CHAM_GD", "NUME_ORDRE", "INST", "PRECISION", "CRITERE", "NOM_CHAM_MED"]:
                if cle in dico:
                    if (dico[cle] is not None):
                        motscsi[cle] = dico[cle]
            if "COMPOSANTE" in dico:
                if (len(dico["COMPOSANTE"]) == 1):
                    motscsi["NOM_CMP"] = dico["COMPOSANTE"][0]
                else:
                    motscsi["NOM_CMP"] = dico["COMPOSANTE"]
#
            motscfa = {}
            motscfa["RESU"] = _F(INFO_MAILLAGE=infomail, **motscsi)
            # print ".. motscfa =", motscfa
#
# 4.3.2.2. Appel de la commande Aster
#
            IMPR_RESU(INFO=infocomm,
                      FORMAT='MED', UNITE=unite_fichier_aster_vers_homard, PROC0='NON',
                      **motscfa)
#
#====================================================================
# 5. ==> Creation des fichiers de donnees pour HOMARD
#====================================================================
#
    # print ".. Debut de 5."
#
    if (mode_homard != "LECT"):
#
# 5.1. ==> Le dictionnaire decrivant le fichier de configuration de HOMARD
#
        dico_configuration = cree_configuration(
            INFO, args, Rep_Calc_ASTER, mode_homard, VERSION_HOMARD, version_perso, Rep_Calc_HOMARD_global,
            niter, fichier_aster_vers_homard, fichier_homard_vers_aster, liste_maillages, liste_champs, liste_zones, liste_front_analytiques)
#
# 5.2. ==> Appel de la fonction de creation
#
        donnees_homard = creation_donnees_homard.creation_donnees_homard(
            self.name, args, dico_configuration)
        if INFO >= 3:
            donnees_homard.quel_mode()
        fic_homard_niter, fic_homard_niterp1 = donnees_homard.creation_configuration(
        )
        donnees_homard.ecrire_fichier_configuration()
#
# 5.3. ==> Donnees en mode d'information
#
        if (mode_homard == "INFO"):
            Nom_Fichier_Donnees = donnees_homard.ecrire_fichier_donnees()
        else:
            Nom_Fichier_Donnees = "0"
#
# 5.4. ==> Impression eventuelle des fichiers crees
#
        # print "Repertoire ", Rep_Calc_HOMARD_global
        if INFO >= 4:
            file_print(Rep_Calc_HOMARD_global)
#    if ( mode_homard == "ADAP" ) :
#      if args.has_key("MAJ_CHAM") :
#        if args.get("MAJ_CHAM") is not None :
#          import time
#          time.sleep(3600)
#
#====================================================================
# 6. Ecriture de la commande d'execution de homard
#====================================================================
    # print ".. Debut de 6."
#
    if (mode_homard != "LECT"):
    # commande = "/bin/cp " + fichier_aster_vers_homard +" " + Rep_Calc_HOMARD_global+"/*hom.med /home/nicolas/Adaptation/."
    # commande = "/bin/cp " + fichier_aster_vers_homard +"  /tmp"
    # os.system(commande)
    # fic = os.path.join(Rep_Calc_HOMARD_global, "HOMARD.Configuration")
    # commande = "/bin/cp " + fic + " /home/nicolas/Adaptation/HOMARD.Configuration.%d" % numero_passage_fonction
    # commande = "/bin/cp " + fic + " /tmp"
    # os.system(commande)
#
        # print "LOGICIEL =", LOGICIEL
        if (LOGICIEL is not None):
            homard = str(LOGICIEL)
        else:
            homard = ExecutionParameter().get_option("prog:homard")
        if not os.path.isfile(str(homard)):
            UTMESS('F', 'HOMARD0_10', valk=homard)
#
        if (INFO == 1):
            saux = "1"
            iaux = 1
        else:
            saux = "2"
            iaux = 2
        if (version_perso):
            saux2 = "1"
        else:
            saux2 = "0"
        EXEC_LOGICIEL(ARGUMENT=(Rep_Calc_HOMARD_global,  # nom du répertoire
                                VERSION_HOMARD,         # version de homard
                                saux,
                                # niveau d information
                                Nom_Fichier_Donnees,
                                # fichier de donnees HOMARD
                                saux2,
                                # version personnelle de homard ?
                                ),
                      LOGICIEL = homard,
                      INFO = iaux,
                      )
#    import time
#    time.sleep(3600)
#
#====================================================================
# 7. ==> Post-traitement eventuel
#====================================================================
#
        d_aux = post_traitement(
            INFO, mode_homard, dico_configuration, Rep_Calc_ASTER)
#
#====================================================================
# 8. ==> Ecriture de la commande de lecture des resultats med
#====================================================================
#
# 8.1. ==> Le maillage
#          On inhibe l'alarme MODELISA5_49 qui apparait car on fait VERIF=NON
#
    if (mode_homard in ["ADAP", "MODI"]):
#
        for dico in liste_maillages:
            # print ".... dico =", dico
            if (dico["Action"] == "A_lire"):
#
                MasquerAlarme('MODELISA5_49')
#
                maillage_a_lire = LIRE_MAILLAGE(
                    UNITE=unite_fichier_homard_vers_aster,
                    FORMAT="MED",
                    NOM_MED=dico["NOM_MED"],
                    VERI_MAIL=_F(VERIF="NON"), INFO_MED=infocomm, INFO=infocomm)
#
                RetablirAlarme('MODELISA5_49')
                self.register_result(maillage_a_lire, dico["Nom_ASTER"])
#
                # print "MAILLAGE =", maillage_a_lire
                # print "NOM_MED =", dico["NOM_MED"]
                if (dico["Type_Maillage"] == "MAILLAGE_NP1"):
                    maillage_np1 = maillage_a_lire
                    maillage_np1_nom_med = dico["NOM_MED"]
                    Nom_Co_Mail_NP1 = maillage_a_lire.getName()
                elif (dico["Type_Maillage"] == "MAILLAGE_NP1_ANNEXE"):
                    Nom_Co_Mail_NP1_ANNEXE = maillage_a_lire.getName()
#
# 8.2. ==> Les champs
#          Les champs ELNO et ELGA ne sont lus qu'en mode lecture
#          Dans les autres modes, on repere s'il y en a pour ne pas supprimer le fichier
#      import time
#      time.sleep(3600)
#
    # print ".. Debut de 8.2"
    garder_fic_homard_aster = 0
#
    if (mode_homard in ["ADAP", "MODI", "LECT"]):
#
        for dico in liste_champs:
#
            usage_champ = dico["Usage_champ"]
            if (usage_champ == "MAJ_CHAM"):
                nom_cham = dico["CHAM_MAJ"]
            elif (usage_champ == "ADD_CHAM"):
                nom_cham = dico["CHAM_GD"]
            else:
                nom_cham = None
            if (nom_cham is not None):
#
# 8.2.1. ==> Constantes
#
                type_cham = dico["TYPE_CHAM"]
                # print ".... TYPE_CHAM :", type_cham
#
                motscsi = {}
                for cle in ["NUME_ORDRE", "INST", "PRECISION", "CRITERE"]:
                    if cle in dico:
                        if (dico[cle] is not None):
                            motscsi[cle] = dico[cle]
                if "NUME_ORDRE" in dico:
                    motscsi["NUME_PT"] = dico["NUME_ORDRE"]
#
                if (usage_champ == "MAJ_CHAM"):
                    motscsi["NOM_CMP_IDEM"] = "OUI"
                elif (usage_champ == "ADD_CHAM"):
                    motscsi["NOM_CMP"] = "X1"
                    motscsi["NOM_CMP_MED"] = "V"
#
# 8.2.2. ==> En mode ADAP ou MODI
#
                if (mode_homard in ["ADAP", "MODI"]):
#
                    if (type_cham[0:2] == "EL"):
                        garder_fic_homard_aster = 1
                    else:
                        le_champ = LIRE_CHAMP(
                            UNITE=unite_fichier_homard_vers_aster, FORMAT="MED",
                            MAILLAGE=maillage_np1, NOM_MAIL_MED=maillage_np1_nom_med,
                            NOM_MED=dico[
                                "NOM_CHAM_MED"], TYPE_CHAM=type_cham,
                            INFO=infocomm, **motscsi)
                        self.register_result(le_champ, nom_cham)
#
# 8.2.3. ==> En mode LECT
#
                else:
#
                    if (type_cham[0:2] == "EL"):
                        le_champ = LIRE_CHAMP(
                            UNITE=unite_fichier_homard_vers_aster, FORMAT="MED",
                            MAILLAGE=maillage_n, NOM_MAIL_MED=maillage_n_nom_med, MODELE=args.get(
                                "MODELE"),
                            NOM_MED=dico[
                                "NOM_CHAM_MED"], TYPE_CHAM=type_cham,
                            INFO=infocomm, **motscsi)
                        self.register_result(le_champ, nom_cham)
#
#====================================================================
# 9. En adaptation, memorisation de ce passage
#====================================================================
#
    if (mode_homard == "ADAP"):
        # print ".. Debut de 8."
#
        ginfos.update_run_params(INFO, niter, previous_mesh, Nom_Co_Mail_NP1,
                                 maillage_np1, maillage_np1_nom_med,
                                 Nom_Co_Mail_NP1_ANNEXE, Rep_Calc_HOMARD_local,
                                 Rep_Calc_HOMARD_global, fic_homard_niterp1,
                                 unite_fichier_homard_vers_aster, liste_champs)
#
#====================================================================
# 10. Menage
#====================================================================
    # print ".. Debut de 10."
#
# 10.1. Liste des fichiers devenus inutiles
#
    if (mode_homard == "LECT"):
        fichier_aster_vers_homard = fichier_echange_nom(
            INFO, 0, Rep_Calc_ASTER)
        fichier_homard_vers_aster = fichier_echange_nom(
            INFO, unite_fichier_homard_vers_aster, Rep_Calc_ASTER)
#
    l_aux = file_remove(
        INFO, mode_homard, Rep_Calc_HOMARD_global, fichier_aster_vers_homard,
        fichier_homard_vers_aster, fic_homard_niterp1, garder_fic_homard_aster)
#
# 10.2. Suppression des fichiers devenus inutiles
#
    for fic in l_aux:
        if os.path.isfile(fic):
            if INFO >= 3:
                print("==> Destruction du fichier", fic)
            try:
                os.remove(fic)
            except os.error as codret_partiel:
                saux = "Code d'erreur de remove : %d" % codret_partiel[0]
                logger.warning(saux + " : " + codret_partiel[1])
                UTMESS("F", 'HOMARD0_5', valk=fic)
#
# 10.3. Liberation du fichier de ASTER vers HOMARD
#
    if (mode_homard != "LECT"):
        DEFI_FICHIER(ACTION="LIBERER",
                     UNITE=unite_fichier_aster_vers_homard,
                     INFO=infocomm)
        # print "Repertoire ", Rep_Calc_HOMARD_global
        # print os.listdir(Rep_Calc_HOMARD_global)
        # print "Repertoire ", Rep_Calc_ASTER
        # print os.listdir(Rep_Calc_ASTER)
#
#====================================================================
# 11. Archivage des répertoires d'adaptation en vue de poursuite
#====================================================================
        # print ".. Debut de 10."
#
    if INFO >= 3:
        print(os.listdir(Rep_Calc_ASTER))
        print("Archivage dans", fichier_archive)
#
# 11.1. Archivage de chacun des passages
#
    laux = ginfos.save_runs()
#
# 11.2. Si on a au moins un cas d'adaptation, archivage
#
    if len(laux) > 0:
#
# 11.2.1. Archivage dans le fichier
#         Remarque : le nom pick.homard.tar est obligatoire car ASTK rapatrie
#                    dans la base tous les fichiers en pick.*
#
        fichier_archive = os.path.join(Rep_Calc_ASTER, "pick.homard.tar")
#
        file = tarfile.open(fichier_archive, "w")
        for rep in laux:
            if INFO >= 3:
                print(".. Insertion de", rep)
            file.add(rep)
        file.close()
#
#====================================================================
#  C'est fini !
#====================================================================
#
    if INFO >= 3:
        print("A la fin, contenu du repertoire de calcul ASTER")
        print(os.listdir(Rep_Calc_ASTER))
#
    # import time
    # time.sleep(3600)
#
    return

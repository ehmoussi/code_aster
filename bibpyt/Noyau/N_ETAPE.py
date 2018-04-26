# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr


"""
    Ce module contient la classe ETAPE qui sert à vérifier et à exécuter
    une commande
"""

# Modules Python
import types
import sys
import string
import os
import linecache
import traceback
from copy import copy

# Modules EFICAS
import N_MCCOMPO
from N_Exception import AsException
import N_utils
from N_utils import AsType
from N_ASSD import ASSD
from N_info import message, SUPERV
from N_types import force_list


class ETAPE(N_MCCOMPO.MCCOMPO):

    """
       Cette classe hérite de MCCOMPO car ETAPE est un OBJECT composite

    """
    nature = "OPERATEUR"

    # L'attribut de classe codex est utilisé pour rattacher le module de calcul éventuel (voir Build)
    # On le met à None pour indiquer qu'il n'y a pas de module de calcul
    # rattaché
    codex = None

    def __init__(self, oper=None, reuse=None, args={}, niveau=4):
        """
        Attributs :
         - definition : objet portant les attributs de définition d'une étape de type opérateur. Il
                        est initialisé par l'argument oper.
         - reuse : indique le concept d'entrée réutilisé. Il se trouvera donc en sortie
                   si les conditions d'exécution de l'opérateur l'autorise
         - valeur : arguments d'entrée de type mot-clé=valeur. Initialisé avec l'argument args.
        """
        self.definition = oper
        self.reuse = reuse
        self.appel = N_utils.callee_where(niveau)
        try:
            self._identifier = "cmd{0}".format(args.pop('identifier'))
        except KeyError:
            self._identifier = "txt{0}".format(self.appel[0])
        self.valeur = args
        self.nettoiargs()
        self.parent = CONTEXT.get_current_step()
        self.etape = self
        self.nom = oper.nom
        self.idracine = oper.label
        self.mc_globaux = {}
        self.sd = None
        self.actif = 1
        self.make_register()
        self.icmd = None

    def make_register(self):
        """
        Initialise les attributs jdc, id, niveau et réalise les
        enregistrements nécessaires
        """
        if self.parent:
            self.jdc = self.parent.get_jdc_root()
            self.id = self.parent.register(self)
            self.niveau = None
        else:
            self.jdc = self.parent = None
            self.id = None
            self.niveau = None

    def nettoiargs(self):
        """
           Cette methode a pour fonction de retirer tous les arguments egaux à None
           de la liste des arguments. Ils sont supposés non présents et donc retirés.
        """
        for k in self.valeur.keys():
            if self.valeur[k] is None:
                del self.valeur[k]

    def McBuild(self):
        """
           Demande la construction des sous-objets et les stocke dans l'attribut
           mc_liste.
        """
        self.mc_liste = self.build_mc()

    def Build_sd(self, nom):
        """
           Construit le concept produit de l'opérateur. Deux cas
           peuvent se présenter :

             - le parent n'est pas défini. Dans ce cas, l'étape prend en charge la création
               et le nommage du concept.

             - le parent est défini. Dans ce cas, l'étape demande au parent la création et
               le nommage du concept.

        """
        # message.debug(SUPERV, "Build_sd %s", self.nom)
        self.sdnom = nom
        try:
            if self.parent:
                sd = self.parent.create_sdprod(self, nom)
                if type(self.definition.op_init) == types.FunctionType:
                    apply(self.definition.op_init, (
                        self, self.parent.g_context))
            else:
                sd = self.get_sd_prod()
                # On n'utilise pas self.definition.op_init car self.parent
                # n'existe pas
                if sd != None and self.reuse == None:
                    # On ne nomme le concept que dans le cas de non reutilisation
                    # d un concept
                    sd.set_name(nom)
        except AsException, e:
            raise AsException("Etape ", self.nom, 'ligne : ', self.appel[0],
                              'fichier : ', self.appel[1], str(e))
        except EOFError:
            raise
        except:
            l = traceback.format_exception(
                sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2])
            raise AsException("Etape ", self.nom, 'ligne : ', self.appel[0],
                              'fichier : ', self.appel[1] + '\n',
                              string.join(l))

        self.Execute()
        return sd

    def Execute(self):
        """
           Cette methode est un point d'entree prevu pour realiser une execution immediatement
           apres avoir construit les mots cles et le concept produit.
           Par defaut, elle ne fait rien. Elle doit etre surchargee dans une autre partie du programme.
        """
        return

    def get_sd_prod(self):
        """
            Retourne le concept résultat de l'étape
            Deux cas :
                     - cas 1 : sd_prod de oper n'est pas une fonction
                       il s'agit d'une sous classe de ASSD
                       on construit le sd à partir de cette classe
                       et on le retourne
                     - cas 2 : il s'agit d'une fonction
                       on l'évalue avec les mots-clés de l'étape (mc_liste)
                       on construit le sd à partir de la classe obtenue
                       et on le retourne
        """
        if type(self.definition.sd_prod) == types.FunctionType:
            d = self.cree_dict_valeurs(self.mc_liste)
            try:
                d['__only_type__'] = True
                sd_prod = apply(self.definition.sd_prod, (), d)
                if self.jdc.fico:
                    self.check_allowed_type(sd_prod)

            except EOFError:
                raise
            except Exception, exc:
                if CONTEXT.debug:
                    traceback.print_exc()
                # "Impossible d'affecter un type au résultat:", str(exc)
                # Do not raise an exception, will be stopped later by V_ETAPE
                sd_prod = lambda etape: None
        else:
            sd_prod = self.definition.sd_prod
        # on teste maintenant si la SD est réutilisée ou s'il faut la créer
        if self.definition.reentrant[0] != 'n' and self.reuse:
            # Le concept produit est specifie reutilise (reuse=xxx). C'est une erreur mais non fatale.
            # Elle sera traitee ulterieurement.
            self.sd = self.reuse
        else:
            self.sd = sd_prod(etape=self)
            # Si l'operateur est obligatoirement reentrant et reuse n'a pas ete specifie, c'est une erreur.
            # On ne fait rien ici. L'erreur sera traiter par la suite.
        # précaution
        if self.sd is not None and not isinstance(self.sd, ASSD):
            raise AsException("""
Impossible de typer le résultat !
Causes possibles :
   Utilisateur : Soit la valeur fournie derrière "reuse" est incorrecte,
                 soit il y a une "," à la fin d'une commande précédente.
   Développeur : La fonction "sd_prod" retourne un type invalide.""")
        return self.sd

    def get_type_produit(self):
        try:
            return self.get_type_produit_brut()
        except:
            return None

    def get_type_produit_brut(self):
        """
            Retourne le type du concept résultat de l'étape
            Deux cas :
              - cas 1 : sd_prod de oper n'est pas une fonction
                il s'agit d'une sous classe de ASSD
                on retourne le nom de la classe
              - cas 2 : il s'agit d'une fonction
                on l'évalue avec les mots-clés de l'étape (mc_liste)
                et on retourne son résultat
        """
        if type(self.definition.sd_prod) == types.FunctionType:
            d = self.cree_dict_valeurs(self.mc_liste)
            sd_prod = apply(self.definition.sd_prod, (), d)
        else:
            sd_prod = self.definition.sd_prod
        return sd_prod

    def check_allowed_type(self, sd_prod, args=None):
        """Check that 'sd_prod' is type declared by the function with '__all__'
        argument.
        """
        check_sdprod(self.nom, self.definition.sd_prod, sd_prod, args)


    def get_etape(self):
        """
           Retourne l'étape à laquelle appartient self
           Un objet de la catégorie etape doit retourner self pour indiquer que
           l'étape a été trouvée
        """
        return self

    def supprime(self):
        """
           Méthode qui supprime toutes les références arrières afin que l'objet puisse
           etre correctement détruit par le garbage collector
        """
        N_MCCOMPO.MCCOMPO.supprime(self)
        self.jdc = None
        self.appel = None
        for name in dir(self):
            if name.startswith('_cache_'):
                setattr(self, name, None)
        if self.sd:
            self.sd.supprime()

    def __del__(self):
        # message.debug(SUPERV, "__del__ ETAPE %s <%s>", getattr(self, 'nom', 'unknown'), self)
        # if self.sd:
            # message.debug(SUPERV, "            sd : %s", self.sd.nom)
        pass

    def get_created_sd(self):
        """Retourne la liste des sd réellement produites par l'étape.
        Si reuse est présent, `self.sd` a été créée avant, donc n'est pas dans
        cette liste."""
        if not self.reuse and self.sd:
            return [self.sd, ]
        return []

    def isactif(self):
        """
           Indique si l'étape est active (1) ou inactive (0)
        """
        return self.actif

    def set_current_step(self):
        """
            Methode utilisee pour que l etape self se declare etape
            courante. Utilise par les macros
        """
        # message.debug(SUPERV, "call etape.set_current_step", stack_id=-1)
        cs = CONTEXT.get_current_step()
        if self.parent != cs:
            raise AsException("L'étape courante", cs.nom, cs,
                              "devrait etre le parent de", self.nom, self)
        else:
            CONTEXT.unset_current_step()
            CONTEXT.set_current_step(self)

    def reset_current_step(self):
        """
              Methode utilisee par l'etape self qui remet son etape parent comme
              etape courante
        """
        cs = CONTEXT.get_current_step()
        if self != cs:
            raise AsException("L'étape courante", cs.nom, cs,
                              "devrait etre", self.nom, self)
        else:
            CONTEXT.unset_current_step()
            CONTEXT.set_current_step(self.parent)

    def issubstep(self, etape):
        """
            Cette methode retourne un entier indiquant si etape est une
            sous etape de self ou non
            1 = oui
            0 = non
            Une étape simple n'a pas de sous etape
        """
        return 0

    def get_file(self, unite=None, fic_origine='', fname=None):
        """
            Retourne le nom du fichier correspondant à un numero d'unité
            logique (entier) ainsi que le source contenu dans le fichier
        """
        if self.jdc:
            return self.jdc.get_file(unite=unite, fic_origine=fic_origine, fname=fname)
        else:
            if unite != None:
                if os.path.exists("fort." + str(unite)):
                    fname = "fort." + str(unite)
            if fname == None:
                raise AsException("Impossible de trouver le fichier correspondant"
                                  " a l unite %s" % unite)
            if not os.path.exists(fname):
                raise AsException("%s n'est pas un fichier existant" % unite)
            fproc = open(fname, 'r')
            text = fproc.read()
            fproc.close()
            text = text.replace('\r\n', '\n')
            linecache.cache[fname] = 0, 0, text.split('\n'), fname
            return fname, text

    def accept(self, visitor):
        """
           Cette methode permet de parcourir l'arborescence des objets
           en utilisant le pattern VISITEUR
        """
        visitor.visitETAPE(self)

    def update_context(self, d):
        """
            Cette methode doit updater le contexte fournit par
            l'appelant en argument (d) en fonction de sa definition
        """
        if type(self.definition.op_init) == types.FunctionType:
            apply(self.definition.op_init, (self, d))
        if self.sd:
            d[self.sd.nom] = self.sd

    def copy(self):
        """ Méthode qui retourne une copie de self non enregistrée auprès du JDC
            et sans sd
        """
        etape = copy(self)
        etape.sd = None
        etape.state = 'modified'
        etape.reuse = None
        etape.sdnom = None
        etape.etape = etape
        etape.mc_liste = []
        for objet in self.mc_liste:
            new_obj = objet.copy()
            new_obj.reparent(etape)
            etape.mc_liste.append(new_obj)
        return etape

    def copy_reuse(self, old_etape):
        """ Méthode qui copie le reuse d'une autre étape.
        """
        if hasattr(old_etape, "reuse"):
            self.reuse = old_etape.reuse

    def copy_sdnom(self, old_etape):
        """ Méthode qui copie le sdnom d'une autre étape.
        """
        if hasattr(old_etape, "sdnom"):
            self.sdnom = old_etape.sdnom

    def reparent(self, parent):
        """
            Cette methode sert a reinitialiser la parente de l'objet
        """
        self.parent = parent
        self.jdc = parent.get_jdc_root()
        self.etape = self
        for mocle in self.mc_liste:
            mocle.reparent(self)
        if self.sd and self.reuse == None:
            self.sd.jdc = self.jdc

    def get_cmd(self, nomcmd):
        """
            Méthode pour recuperer la definition d'une commande
            donnee par son nom dans les catalogues declares
            au niveau du jdc
            Appele par un ops d'une macro en Python
        """
        return self.jdc.get_cmd(nomcmd)

    def copy_intern(self, etape):
        """
            Méthode permettant lors du processus de recopie de copier
            les elements internes d'une etape dans une autre
        """
        return

    def full_copy(self, parent=None):
        """
           Méthode permettant d'effectuer une copie complète
           d'une étape (y compris concept produit, éléments internes)
           Si l'argument parent est fourni, la nouvelle étape
           aura cet objet comme parent.
        """
        new_etape = self.copy()
        new_etape.copy_reuse(self)
        new_etape.copy_sdnom(self)
        if parent:
            new_etape.reparent(parent)
        if self.sd:
            new_sd = self.sd.__class__(etape=new_etape)
            new_etape.sd = new_sd
            if self.reuse == None:
                new_etape.parent.NommerSdprod(new_sd, self.sd.nom)
            else:
                new_sd.set_name(self.sd.nom)
        new_etape.copy_intern(self)
        return new_etape

    def reset_jdc(self, new_jdc):
        """
           Reinitialise le nommage du concept de l'etape lors d'un changement de jdc
        """
        if self.sd and self.reuse == None:
            self.parent.NommerSdprod(self.sd, self.sd.nom)

    def is_include(self):
        """Permet savoir si on a affaire à la commande INCLUDE
        car le comportement de ces macros est particulier.
        """
        return self.nom.startswith('INCLUDE')

    def sd_accessible(self):
        """Dit si on peut acceder aux "valeurs" (jeveux) de l'ASSD produite par l'étape.
        """
        if CONTEXT.debug:
            print '`- ETAPE sd_accessible :', self.nom
        return self.parent.sd_accessible()

    def get_concept(self, nomsd):
        """
            Méthode pour recuperer un concept à partir de son nom
        """
        # pourrait être appelée par une commande fortran faisant appel à des fonctions python
        # on passe la main au parent
        return self.parent.get_concept(nomsd)


def check_sdprod(command, func_prod, sd_prod, args=None):
    """Check that 'sd_prod' is type allowed by the function 'func_prod'
    with '__all__' argument.
    """
    from Noyau.N_CR import CR
    from code_aster.Cata.Language.SyntaxUtils import add_none_sdprod
    def _name(class_):
        return getattr(class_, '__name__', class_)

    if type(func_prod) != types.FunctionType:
        return

    cr = CR()
    args = args or {}
    add_none_sdprod(func_prod, args)
    args['__all__'] = True
    # eval sd_prod with __all__=True + None for other arguments
    try:
        allowed = force_list(apply(func_prod, (), args))
        if sd_prod and sd_prod not in allowed:
            cr.fatal("Error: {0}: type '{1}' is not in the list returned "
                     "by the 'sd_prod' function with '__all__=True': {2}"
                     .format(command, _name(sd_prod),
                             [_name(i) for i in allowed]))
    except Exception as exc:
        print "ERROR:", str(exc)
        cr.fatal("Error: {0}: the 'sd_prod' function must support "
                 "the '__all__=True' argument".format(command))
    if not cr.estvide():
        print(str(cr))
        raise TypeError(str(cr))

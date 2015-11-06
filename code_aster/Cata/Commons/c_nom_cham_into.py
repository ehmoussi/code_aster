# coding=utf-8

from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2015  EDF R&D                WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: josselin.delmas at edf.fr

class NOM_CHAM_INTO:  #COMMUN#
    """
    """
    def Tous(self):
        """ Tous les champs
        """
        self.all_phenomenes = ('CONTRAINTE', 'DEFORMATION', 'ENERGIE', 'CRITERES',
                               'VARI_INTERNE', 'HYDRAULIQUE', 'THERMIQUE',
                               'ACOUSTIQUE', 'FORCE', 'ERREUR', 'DEPLACEMENT',
                               'METALLURGIE', 'AUTRES')
        d = {}
        d['CONTRAINTE'] = {
            "EFGE_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Efforts généralisés aux points de Gauss"), ),
            "EFGE_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Efforts généralisés aux noeuds par élément"), ),
            "EFGE_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Efforts généralisés aux noeuds"), ),
            "SIEF_ELGA":        ( ("lin",),
                                 _(u"Contraintes et efforts aux points de Gauss"), ),
            "SIEF_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Contraintes et efforts aux noeuds par élément"), ),
            "SIEF_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Contraintes et efforts aux noeuds"), ),
            "SIGM_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Contraintes aux points de Gauss"), ),
            "SIGM_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Contraintes aux noeuds par élément"), ),
            "SIGM_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Contraintes aux noeuds"), ),
            "SIPM_ELNO":        ( ("lin","nonlin"),
                                 _(u"Contraintes aux noeuds par élément pour les éléments de poutre"), ),
            "SIPO_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Contraintes aux noeuds par élément pour les éléments de poutre"), ),
            "SIPO_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Contraintes aux noeuds pour les éléments de poutre"), ),
            "SIRO_ELEM":        ( ("lin", "nonlin",),
                                 _(u"Contraintes de rosette par élément"), ),
        }
        d['DEFORMATION'] = {
            "DEGE_ELGA":        ( ("lin", "nonlin",),          
                                 _(u"Déformations généralisées aux points de Gauss"), ),
            "DEGE_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations généralisées aux noeuds par élément"), ),
            "DEGE_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations généralisées aux noeuds"), ),
            "EPFD_ELGA":        ( ("nonlin",),
                                 _(u"Déformations de fluage de déssication aux points de Gauss"), ),
            "EPFD_ELNO":        ( ("nonlin",),
                                 _(u"Déformations de fluage de déssication aux noeuds par élément"), ),
            "EPFD_NOEU":        ( ("nonlin",),
                                 _(u"Déformations de fluage de déssication aux noeuds"), ),
            "EPFP_ELGA":        ( ("nonlin",),
                                 _(u"Déformations de fluage propre aux points de Gauss"), ),
            "EPFP_ELNO":        ( ("nonlin",),
                                 _(u"Déformations de fluage propre aux noeuds par élément"), ),
            "EPFP_NOEU":        ( ("nonlin",),
                                 _(u"Déformations de fluage propre aux noeuds"), ),
            "EPME_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques en petits déplacements aux points de Gauss"), ),
            "EPME_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques en petits déplacements aux noeuds par élément"), ),
            "EPME_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques en petits déplacements aux noeuds"), ),
            "EPMG_ELGA":        ( ("nonlin",),
                                 _(u"Déformations mécaniques en grands déplacements aux points de Gauss"), ),
            "EPMG_ELNO":        ( ("nonlin",),
                                 _(u"Déformations mécaniques en grands déplacements aux noeuds par élément"), ),
            "EPMG_NOEU":        ( ("nonlin",),
                                 _(u"Déformations mécaniques en grands déplacements aux noeuds"), ),
            "EPSG_ELGA":        ( ("lin","nonlin",),
                                 _(u"Déformations de Green-Lagrange aux points de Gauss"), ),
            "EPSG_ELNO":        ( ("lin","nonlin",),
                                 _(u"Déformations de Green-Lagrange aux noeuds par élément"), ),
            "EPSG_NOEU":        ( ("lin","nonlin",),
                                 _(u"Déformations de Green-Lagrange aux noeuds"), ),
            "EPSI_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Déformations aux points de Gauss"), ),
            "EPSI_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations aux noeuds par élément"), ),
            "EPSI_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations aux noeuds"), ),
            "EPSP_ELGA":        ( ("nonlin",),
                                 _(u"Déformations anélastique aux points de Gauss"), ),
            "EPSP_ELNO":        ( ("nonlin",),
                                 _(u"Déformations anélastique aux noeuds par élément"), ),
            "EPSP_NOEU":        ( ("nonlin",),
                                 _(u"Déformations anélastique aux noeuds"), ),
            "EPVC_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Déformations dues aux variables de commande aux points de Gauss"), ),
            "EPVC_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations dues aux variables de commande aux noeuds par élément"), ),
            "EPVC_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations dues aux variables de commande aux noeuds"), ),
        }
        d['ENERGIE'] = {
            "DISS_ELEM":        ( ("lin", "nonlin",),
                                 _(u"Énergie de dissipation par élément"), ),
            "DISS_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie de dissipation aux points de Gauss"), ),
            "DISS_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie de dissipation aux noeuds par élément"), ),
            "DISS_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie de dissipation aux noeuds"), ),
            "ECIN_ELEM":        ( ("lin",),
                                 _(u"Énergie cinétique par élément"), ),
            "ENEL_ELEM":        ( ("lin", "nonlin",),
                                 _(u"Énergie élastique par élément"), ),
            "ENEL_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie élastique aux points de Gauss"), ),
            "ENEL_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie élastique aux noeuds par élément"), ),
            "ENEL_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Densité d'énergie élastique aux noeuds"), ),
            "EPOT_ELEM":        ( ("lin",),
                                 _(u"Énergie potentielle de déformation élastique par élément"), ),
            "ETOT_ELEM":        ( ("lin", "nonlin",),
                                 _(u"Incrément d'énergie de déformation totale par élément"), ),
            "ETOT_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Incrément de densité d'énergie de déformation totale aux points de Gauss"), ),
            "ETOT_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Incrément de densité d'énergie de déformation totale aux noeuds par élément"), ),
            "ETOT_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Incrément de densité d'énergie de déformation totale aux noeuds"), ),
        }                       
        d['CRITERES'] = {
            "DERA_ELGA":        ( ("nonlin",),
                                 _(u"Indicateur local de décharge et de perte de radialité aux points de Gauss"), ),
            "DERA_ELNO":        ( ("nonlin",),
                                 _(u"Indicateur local de décharge et de perte de radialité aux noeuds par élément"), ),
            "DERA_NOEU":        ( ("nonlin",),
                                 _(u"Indicateur local de décharge et de perte de radialité aux noeuds"), ),
            "ENDO_ELGA":        ( ("nonlin",),
                                 _(u"Dommage de Lemaître-Sermage aux points de Gauss"), ),
            "ENDO_ELNO":        ( ("nonlin",),
                                 _(u"Dommage de Lemaître-Sermage aux noeuds par élément"), ),
            "ENDO_NOEU":        ( ("nonlin",),
                                 _(u"Dommage de Lemaître-Sermage aux noeuds"), ),
            "EPEQ_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Déformations équivalentes aux points de Gauss"), ),
            "EPEQ_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations équivalentes aux noeuds par élément"), ),
            "EPEQ_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations équivalentes aux noeuds"), ),
            "EPMQ_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques équivalentes aux points de Gauss"), ),
            "EPMQ_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques équivalentes aux noeuds par élément"), ),
            "EPMQ_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Déformations mécaniques équivalentes aux noeuds"), ),
            "INDL_ELGA":        ( ("nonlin",),
                                 _(u"Indicateur de localisation aux points de Gauss"), ),
            "PDIL_ELGA":        ( ("nonlin",),
                                 _(u"Module de rigidité de micro-dilatation"), ),
            "SIEQ_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Contraintes équivalentes aux points de Gauss"), ),
            "SIEQ_ELNO":        ( ("lin", "nonlin",),
                                 _(u"Contraintes équivalentes aux noeuds par élément"), ),
            "SIEQ_NOEU":        ( ("lin", "nonlin",),
                                 _(u"Contraintes équivalentes aux noeuds"), ),
        }
        d['VARI_INTERNE'] = {
            "VAEX_ELGA":        ( ("nonlin",),
                                 _(u"Extraction d'une variable interne aux points de Gauss"), ),
            "VAEX_ELNO":        ( ("nonlin",),
                                 _(u"Extraction d'une variable interne aux noeuds pas élément"), ),
            "VAEX_NOEU":        ( ("nonlin",),
                                 _(u"Extraction d'une variable interne aux noeuds"), ),
            "VARC_ELGA":        ( ("lin", "nonlin",),
                                 _(u"Variables de commande aux points de Gauss"), ),
            "VARI_ELNO":        ( ("nonlin",),
                                 _(u"Variables internes aux noeuds pas élément"), ),
            "VARI_NOEU":        ( ("nonlin",),
                                 _(u"Variables internes aux noeuds"), ),
        }
        d['HYDRAULIQUE'] = {
            "FLHN_ELGA":        ( ("nonlin",),
                                 _(u"Flux hydrauliques aux points de Gauss"), ),
        }
        d['THERMIQUE'] = {
            "TEMP_ELGA":        ( (),
                                 _(u"Température aux points de Gauss"), ),
            "FLUX_ELGA":        ( (),
                                 _(u"Flux thermique aux points de Gauss"), ),
            "FLUX_ELNO":        ( (),
                                 _(u"Flux thermique aux noeuds par élément"), ),
            "FLUX_NOEU":        ( (),
                                 _(u"Flux thermique aux noeuds"), ),
            "HYDR_NOEU":        ( (),
                                 _(u"Hydratation aux noeuds"), ),
            "SOUR_ELGA":        ( (),
                                 _(u"Source de chaleur à partir d'un potentiel électrique"), ),
            "ETHE_ELEM":        ( (),
                                 _(u"Énergie dissipée thermiquement"), ),
        }
        d['ACOUSTIQUE'] = {
            "PRAC_ELNO":        ( (),
                                 _(u"Pression acoustique aux noeuds par élément"), ),
            "PRAC_NOEU":        ( (),
                                 _(u"Pression acoustique aux noeuds"), ),
            "PRME_ELNO":        ( (),
                                 _(u"Pression aux noeuds par élément pour les éléments FLUIDE"), ),
            "INTE_ELNO":        ( (),
                                 _(u"Intensité acoustique aux noeuds par élément"), ),
            "INTE_NOEU":        ( (),
                                 _(u"Intensité acoustique aux noeuds"), ),
        }
        d['FORCE'] = {
            "FORC_NODA":        ( (),
                                 _(u"Forces nodales"), ),
            "REAC_NODA":        ( (),
                                 _(u"Réactions nodales"), ),
        }
        d['ERREUR'] = {
            "SIZ1_NOEU":        ( (),
                                 _(u"Contraintes lissées de Zhu-Zienkiewicz version 1 aux noeuds"), ),
            "ERZ1_ELEM":        ( (),
                                 _(u"Indicateur d'erreur de Zhu-Zienkiewicz version 1 par élément"), ),
            "SIZ2_NOEU":        ( (),
                                 _(u"Contraintes lissées de Zhu-Zienkiewicz version 2 aux noeuds"), ),
            "ERZ2_ELEM":        ( (),
                                 _(u"Indicateur d'erreur de Zhu-Zienkiewicz version 2 par élément"), ),
            "ERME_ELEM":        ( (),
                                 _(u"Indicateur d'erreur en résidu en mécanique par élément"), ),
            "ERME_ELNO":        ( (),
                                 _(u"Indicateur d'erreur en résidu en mécanique aux noeuds par élément"), ),
            "ERME_NOEU":        ( (),
                                 _(u"Indicateur d'erreur en résidu en mécanique aux noeuds"), ),
            "QIRE_ELEM":        ( (),
                                 _(u"Indicateur d'erreur en quantités d'intérêt en résidu par élément"), ),
            "QIRE_ELNO":        ( (),
                                 _(u"Indicateur d'erreur en quantités d'intérêt en résidu aux noeuds par élément"), ),
            "QIRE_NOEU":        ( (),
                                 _(u"Indicateur d'erreur en quantités d'intérêt en résidu aux noeuds"), ),
            "QIZ1_ELEM":        ( (),
                                 _(u"Indicateur d'erreur en quantités d'intérêt de Zhu-Zienkiewicz version 1 par élément"), ),
            "QIZ2_ELEM":        ( (),
                                 _(u"Indicateur d'erreur en quantités d'intérêt de Zhu-Zienkiewicz version 2 par élément"), ),
            "SING_ELEM":        ( (),
                                 _(u"Degré de singularité par élément"), ),
            "SING_ELNO":        ( (),
                                 _(u"Degré de singularité aux noeuds par élément"), ),
            "ERTH_ELEM":        ( (),
                                 _(u"Indicateur d'erreur en résidu en thermique par élément"), ),
            "ERTH_ELNO":        ( (),
                                 _(u"Indicateur d'erreur en résidu en thermique aux noeuds par élément"), ),
            "ERTH_NOEU":        ( (),
                                 _(u"Indicateur d'erreur en résidu en thermique aux noeuds"), ),
        }
        d['METALLURGIE'] = {
            "DURT_ELNO":        ( (),
                                 _(u"Dureté aux noeuds par élément"), ),
            "DURT_NOEU":        ( (),
                                 _(u"Dureté aux noeuds"), ),
            "META_ELNO":        ( (),
                                 _(u"Proportion de phases métallurgiques aux noeuds par élément"), ),
            "META_NOEU":        ( (),
                                 _(u"Proportion de phases métallurgiques aux noeuds"), ),
        }
        d['DEPLACEMENT'] = {
            "ACCE":             ( (),
                                 _(u"Accélération aux noeuds"), ),
            "ACCE_ABSOLU":      ( (),
                                 _(u"Accélération absolue aux noeuds"), ),
            "DEPL":             ( (),
                                 _(u"Déplacements aux noeuds"), ),
            "DEPL_ABSOLU":      ( (),
                                 _(u"Déplacements absolus aux noeuds"), ),
            "STRX_ELGA":        ( (),
                                 _(u"Efforts généralisés à partir des déplacements en linéaire aux points de Gauss"), ),
            "TEMP":             ( (),
                                 _(u"Température aux noeuds"), ),
            "VITE":             ( (),
                                 _(u"Vitesse aux noeuds"), ),
            "CONT_NOEU":        ( (),
                                 _(u"Statuts de contact aux noeuds"), ),
            "VARI_ELGA":        ( (),
                                 _(u"Variables internes aux points de Gauss"), ),
            "VITE_ABSOLU":      ( (),
                                 _(u"Vitesse absolue aux noeuds"), ),
        }
        d['AUTRES'] = {
            "COHE_ELEM":        ( ("nonlin",),
                                 _(u"Variables internes cohésives XFEM"), ),
            "COMPORTEMENT":     ( (),
                                 _(u"Carte de comportement mécanique"), ),
            "COMPORTHER":       ( (),
                                 _(u"Carte de comportement thermique"), ),
            "DEPL_VIBR":        ( (),
                                 _(u"Déplacement pour mode vibratoire"), ),
            "DIVU":             ( (),
                                 _(u"Déformation volumique en THM"), ),
            "EPSA_ELNO":        ( (),
                                 _(u"Déformations anélastique aux noeuds par élément"), ),
            "EPSA_NOEU":        ( (),
                                 _(u"Déformations anélastique aux noeuds"), ),
            "FERRAILLAGE":      ( ("lin",),
                                 _(u"Densité de ferraillage"), ),
            "FSUR_2D":          ( (),
                                 _(u"Chargement de force surfacique en 2D"), ),
            "FSUR_3D":          ( (),
                                 _(u"Chargement de force surfacique en 3D"), ),
            "FVOL_2D":          ( (),
                                 _(u"Chargement de force volumique en 2D"), ),
            "FVOL_3D":          ( (),
                                 _(u"Chargement de force volumique en 3D"), ),
            "COEF_H":           ( (),
                                 _(u"Coefficient d'échange constant par élément"), ),
            "T_EXT":            ( (),
                                 _(u"Température extérieure constante par élément"), ),
            "HYDR_ELNO":        ( (),
                                 _(u"Hydratation aux noeuds par élément"), ),
            "IRRA":             ( (),
                                 _(u"Irradition aux noeuds"), ),
            "MODE_FLAMB":       ( (),
                                 _(u"Mode de flambement"), ),
            "MODE_STAB":        ( (),
                                 _(u"Mode de stabilité"), ),
            "NEUT":             ( (),
                                 _(u"Variable de commande 'neutre'"), ),
            "PRES":             ( (),
                                 _(u"Chargement de pression"), ),
            "PTOT":             ( (),
                                 _(u"Pression totale de fluide en THM"), ),
            "SISE_ELNO":        ( (),
                                 _(u"Contraintes aux noeuds par sous-élément"), ),
            "SPMX_ELGA":        ( (),
                                 _(u"Valeurs maximum sur un sous-point"), ),
            "THETA":            ( (),
                                 _(u"Champ theta"), ),
            "VITE_VENT":        ( (),
                                 _(u"Chargement vitesse du vent"), ),
        }
        for typ in ('ELGA', 'ELNO', 'ELEM', 'NOEU', 'CART'):
            for i in range(1, 11):
                d['AUTRES']['UT%02d_%s' % (i, typ)]=( (),
                                 _(u"Champ utilisateur numéro %02d_%s" % (i, typ)), )
        self.d_all = d
        return

    def CheckPhenom(self):
        """ Vérification de la cohérence entre les phenomènes et les clés
        """
        l_keys = list(self.d_all.keys())
        l_phen = list(self.all_phenomenes)
        uniq_keys = set(l_keys)
        uniq_phen = set(l_phen)
        if len(l_keys) != len(uniq_keys) or len(l_phen) != len(uniq_phen) :
            for i in uniq_keys :
                l_keys.remove(i)
            assert len(l_keys) == 0, 'Keys must be unique: %s' % l_keys
            for i in uniq_phen :
                l_phen.remove(i)
            assert len(l_phen) == 0, 'Phenomenon must be unique: %s' % l_phen
        if len(l_keys) > len(l_phen) :
            for i in l_phen :
                l_keys.remove(i)
            assert len(l_keys) == 0, 'Key %s not listed in the list of phenomenons' % l_keys
        if len(l_keys) < len(l_phen) :
            for i in l_keys:
                l_phen.remove(i)
            assert len(l_phen) == 0, 'Phenomenon %s not known as a key' % l_phen


    def CheckField(self):
        """ Vérification des doublons dans les noms des champs
        """
        l_cham = []
        for phen in self.all_phenomenes:
            l_cham.extend(self.d_all[phen].keys())
        uniq = set(l_cham)
        if len(l_cham) != len(uniq):
            for i in uniq:
                l_cham.remove(i)
            assert len(l_cham) == 0, 'Field names must be unique: %s' % l_cham


    def InfoChamps(self, l_nom_cham):
        """ on renvoie juste les informations relatives au(x) champ(s)
        """
        d_cham = {}.fromkeys( l_nom_cham, ( '', '', '' ) )
        for nom_cham in l_nom_cham:
            for phen in self.all_phenomenes:
              for cham in self.d_all[phen].keys():
                  if nom_cham == cham:
                      cate = self.d_all[phen][cham][0]
                      helptxt = self.d_all[phen][cham][1]
                      d_cham[nom_cham] = ( phen, cate, helptxt )
        return d_cham

    def Filtre(self, *l_typ_cham, **kwargs):
        """ Check des doublons
        """
        phenomene   = kwargs.get('phenomene')
        categorie   = kwargs.get('categorie')
        # Construction de la liste des champs en tenant compte des eventuels filtre (phenomene, categorie, l_typ_cham)
        # ------------------------------------------------------------------------------------------------------------
        l_cham = []
        # Filtre par phenomene
        if phenomene is None:
            l_phen = self.all_phenomenes
        else:
            l_phen = [ phenomene ]
        for phen in l_phen:
            # parcours de tous les champs
            for cham in self.d_all[phen].keys():
               isok = True
               # Filtre par categorie
               if categorie is not None:
                 lcat = self.d_all[phen][cham][0]
                 if type(lcat) not in (tuple, list):
                     lcat = [lcat, ]
                 if categorie in lcat:
                     isok = True
                 else:
                     isok = False
               if isok:
                 l_cham.append(cham)
        l_cham.sort()
        # Filtre sur les types de champs
        if len(l_typ_cham) == 0:
            return tuple(l_cham)
        l_ncham = []
        for typ in l_typ_cham :
            for cham in l_cham :
                if typ in cham.split('_'):
                  l_ncham.append(cham)
        return tuple(l_ncham)

    def __init__(self):
        self.Tous()
        # check les doublons (fonctionnalite developpeur permettant de detecter les doublons dans les champs)
        if 1:
            self.CheckPhenom()
            self.CheckField()

    def __call__(self, *l_typ_cham, **kwargs):
        """Cette fonction retourne la liste des "into" possibles pour le mot-clé NOM_CHAM.
        C'est à dire les noms de champs des SD RESULTAT (DATA de la routine RSCRSD).
        l_typ_cham : rien ou un ou plusieurs parmi 'ELGA', 'ELNO', 'NOEU', 'ELEM'.
        kwargs : un dictionnaire de mot-cles, les cles parmis : 
          'phenomene'  : retourne la liste des champs en filtrant par le phenomene (eventuellement mixe avec le suivant)
          'categorie'  : retourne la liste des champs en filtrant par le phenomene (eventuellement mixe avec le precedent)
          'l_nom_cham' : (une liste ou un string) retourne uniqement les informations relatives au champ precise en argument
        """
        l_nom_cham  = kwargs.get('l_nom_cham')
        if type(l_nom_cham) == str:
            l_nom_cham = [ l_nom_cham ]
        if l_nom_cham:
            return self.InfoChamps(l_nom_cham)
        else:
            return self.Filtre(*l_typ_cham, **kwargs)


C_NOM_CHAM_INTO = NOM_CHAM_INTO()

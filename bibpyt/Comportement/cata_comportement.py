#@ MODIF cata_comportement Comportement  DATE 07/12/2010   AUTEUR GENIAUT S.GENIAUT 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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

import os

"""
------------------------------------------------------------------------
              Module catalogue de loi de comportement.
------------------------------------------------------------------------
   
   Contenu du module :

   - CataLoiComportement : le catalogue
      M�thodes : add, get, create, get_info, get_vari, query, get_algo
   
   - LoiComportement : l'objet loi de comportement
      D�finition, stockage et r�cup�ration des valeurs
   
   - KIT : permet l'assemblage de loi de comportement
   
   
Interfaces Fortran/Python :

   Fonctionnement dans NMDORC : exemple VMIS_ISOT_TRAC + DEBORST
      1. on construit le comportement rencontr�
         CALL LCCREE(NBKIT, LKIT, COMPOR)
         ==> comport = catalc.create(*list_kit)
      
      2. r�cup�ration du num�ro de routine et le nbre de variables internes
         CALL LCINFO(COMPOR, NUMLC, NBVARI)
         ==> num_lc, nb_vari = catalc.get_info(COMPOR)
      
      3. r�cup�re la liste des variables internes
         CALL LCVARI(COMPOR, NBVARI, LVARI)
         ==> nom_vari = catalc.get_vari(COMPOR)
      
      4. est-ce que VALEUR est un valeur autoris�e de PROPRIETE ?
         CALL LCTEST(COMPOR, PROPRIETE, VALEUR, IRET)
         ==> iret = catalc.query(COMPOR, PROPRIETE, VALEUR)

      5. r�cup�re le nom du 1er algorithme d'integration
         CALL LCALGO(COMPOR, ALGO)
         ==> algo_inte = catalc.get_algo(COMPOR)
      
------------------------------------------------------------------------

"""

__properties__ = ('deformation', 'mc_mater', 'modelisation', 'nb_vari',
                  'nom_varc', 'nom_vari', 'proprietes', 'algo_inte',
                  'type_matr_tang')

# -----------------------------------------------------------------------------
class CataComportementError(Exception):
   pass

# -----------------------------------------------------------------------------
# utilitaires
def force_to_tuple(value):
   """Retourne syst�matiquement un tuple (vide si value==None).
   """
   if value is None:
      return tuple()
   if type(value) not in (list, tuple):
      value = [value,]
   return tuple(value)

def check_type(typ, value, accept_None=False):
   """V�rification de type.
   """
   l_typ = force_to_tuple(typ)
   l_val = force_to_tuple(value)
   for val in l_val:
      if val is None and accept_None:
         pass
      elif type(val) not in l_typ:
         raise CataComportementError, "%r n'est pas d'un type autoris� : %r" % (val, l_typ)

def union(args):
   """Union de N s�quences.
   """
   res = []
   for seq in args:
      if seq is None:
         continue
      assert type(seq) in (list, tuple)
      res.extend(seq)
   return tuple(res)

def intersection(args):
   """Intersection de N s�quences.
   """
   if len(args) < 1:
      return tuple()
   res = list(args[0])
   for seq in args[1:]:
      if seq is None:
         continue
      assert type(seq) in (list, tuple), seq
      d = {}.fromkeys(res, 1)
      res = [elt for elt in seq if d.get(elt)]
   return tuple(res)

def first(args):
   """Retourne la 1�re valeur.
   """
   return args[0]

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class Base(object):
   """Classe de base : partie commune loi de comportement/kit.
   """

# -----------------------------------------------------------------------------
   def copy(self):
      """Copie d'un objet LoiComportement.
      """
      import copy
      return copy.copy(self)

# -----------------------------------------------------------------------------
   def gen_property(prop, typ, comment):
      """G�n�re la propri�t� 'prop' avec ses fonctions get, set, del.
      """
      def getfunc(comport):
         return getattr(comport, '_' + prop)
      
      def setfunc(comport, value):
         check_type(typ, value)
         setattr(comport, '_' + prop, force_to_tuple(value))
      
      def delfunc(comport):
         setattr(comport, '_' + prop, None)
      
      return property(getfunc, setfunc, delfunc, comment)
   gen_property = staticmethod(gen_property)

# -----------------------------------------------------------------------------
   def gen_getfunc(oper, prop):
      """G�n�re la fonction get de la propri�t� 'prop'.
      'oper' est une fonction qui prend N valeurs de 'prop' et en retourne une.
      """
      def func(kit):
         return oper([getattr(comport, prop) for comport in kit.list_comport])
      return func
   gen_getfunc = staticmethod(gen_getfunc)
   
# -----------------------------------------------------------------------------
   def dict_info(self):
      dico = {
         'nom'    : self.nom,
         'num_lc' : self.num_lc,
         'doc'    : self.doc,
      }
      for attr in __properties__:
         dico[attr] = getattr(self, attr)
      return dico
   
   def short_repr(self):
      return "<%s(%x,%r)>" % (self.__class__.__name__, id(self), self.nom)

   def long_repr(self):
      template = """Loi de comportement : %(nom)s
'''%(doc)s'''
   routine                    : %(num_lc)r
   nb de variables internes   : %(nb_vari)r
   nom des variables internes : %(nom_vari)r
   mod�lisations disponibles  : %(modelisation)r
   types de d�formations      : %(deformation)r
   mots-cl�s du mat�riau      : %(mc_mater)r
   variables de commandes     : %(nom_varc)r
   sch�mas d'int�gration      : %(algo_inte)r
   type de matrice tangente   : %(type_matr_tang)r
   propri�t�s suppl�mentaires : %(proprietes)r
"""
      return template % self.dict_info()

   def __repr__(self):
      # par d�faut
      return self.long_repr()

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class LoiComportement(Base):
   """D�finition d'une loi de comportement.
   
   nom_vari, proprietes : definition, affectation de valeurs
   mc_mater : besoin de regles ENSEMBLE, AU_MOINS_UN, UN_PARMI
   modelisation, deformation, nom_varc, algo_inte, type_matr_tang : listes des valeurs acceptees
   """
   def __init__(self, nom, num_lc, doc='', **kwargs):
      """Initialisations.
      """
      self.nom    = nom
      self.num_lc = num_lc
      self.doc    = doc
      for prop in __properties__:
         setattr(self, '_' + prop, None)
      # propri�t�s fournies
      for prop in [k for k in kwargs.keys() if k in __properties__]:
         setattr(self, prop, kwargs.get(prop))

# -----------------------------------------------------------------------------
   def get_nb_vari(self):
      return self._nb_vari or 0

   def set_nb_vari(self, value):
      check_type((long, int), value)
      self._nb_vari = value
      self.check_vari()

   def del_nb_vari(self):
      self._nb_vari = None

   nb_vari = property(get_nb_vari, set_nb_vari, del_nb_vari, "Nombre de variables internes")

# -----------------------------------------------------------------------------
   def get_nom_vari(self):
      return self._nom_vari

   def set_nom_vari(self, value):
      check_type((str, unicode), value)
      self._nom_vari = force_to_tuple(value)
      self.check_vari()

   def del_nom_vari(self):
      self._nom_vari = None

   nom_vari = property(get_nom_vari, set_nom_vari, del_nom_vari, "Noms des variables internes")

# -----------------------------------------------------------------------------
#  d�finition des propri�t�s simples (juste v�rification de type � l'affectation)
   mc_mater       = Base.gen_property('mc_mater',       (str, unicode), "Mots-cl�s mat�riaux")
   modelisation   = Base.gen_property('modelisation',   (str, unicode), "Mod�lisations")
   deformation    = Base.gen_property('deformation',    (str, unicode), "Types de d�formation")
   nom_varc       = Base.gen_property('nom_varc',       (str, unicode), "Noms des variables de commandes")
   algo_inte      = Base.gen_property('algo_inte',      (str, unicode), "Sch�ma d'int�gration")
   type_matr_tang = Base.gen_property('type_matr_tang', (str, unicode), "Type de matrice tangente")
   proprietes     = Base.gen_property('proprietes',     (str, unicode), "Propri�t�s")

# -----------------------------------------------------------------------------
   def check_vari(self):
      """V�rifie la coh�rence de la d�finition des variables internes.
      """
      if self._nb_vari is not None and self._nom_vari is not None \
         and self._nb_vari != len(self._nom_vari):
         print self
         raise CataComportementError, "Nombre de variables internes = %d, incoh�rent avec la liste des variables internes %s" % (self._nb_vari, self._nom_vari)


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class KIT(Base):
   """D�finit un assemblage de loi de comportement par KIT par un 'nom' et une
   liste de comportements.
   """
   def __init__(self, nom, *list_comport):
      """Initialisations.
      """
      if not type(nom) in (str, unicode):
         raise CataComportementError, "'KIT' : argument 1 (nom) de type invalide"
      self.nom          = nom
      self.list_comport = [comport.copy() for comport in list_comport]
      self.list_nom     = [comport.nom for comport in self.list_comport]
      txt = ['Assemblage compos� de %s' % ', '.join(self.list_nom)]
      for comport in self.list_comport:
         if comport.doc:
            txt.append('%s : %s' % (comport.nom, comport.doc))
      self.doc = os.linesep.join(txt)

# -----------------------------------------------------------------------------
#  definition des propri�t�s (seulement la m�thode get)

   num_lc         = property(Base.gen_getfunc(first,        'num_lc'))
   nb_vari        = property(Base.gen_getfunc(sum,          'nb_vari'))
   nom_vari       = property(Base.gen_getfunc(union,        'nom_vari'))
   mc_mater       = property(Base.gen_getfunc(union,        'mc_mater'))
   modelisation   = property(Base.gen_getfunc(intersection, 'modelisation'))
   deformation    = property(Base.gen_getfunc(intersection, 'deformation'))
   nom_varc       = property(Base.gen_getfunc(intersection, 'nom_varc'))
   algo_inte      = property(Base.gen_getfunc(intersection, 'algo_inte'))
   type_matr_tang = property(Base.gen_getfunc(intersection, 'type_matr_tang'))
   proprietes     = property(Base.gen_getfunc(intersection, 'proprietes'))


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class KIT_META(KIT):
   """D�finit un assemblage de loi de comportement par KIT par un 'nom' et une
   liste de comportements.
   """
   
   def __init__(self, nom, *list_comport):
      """Initialisations.
      """
      if len(list_comport) != 2:
         raise CataComportementError, "KIT_META : il faut 2 comportements"
      elif not list_comport[0].nom.startswith('META_'):
         raise CataComportementError, "KIT_META : le premier doit etre un comportement META_xx"
      KIT.__init__(self, nom, *list_comport)

      self.init_nb_vari()

# -----------------------------------------------------------------------------
   def init_nb_vari(self):
      """Composition des variables internes.
      """
      meta, mat = self.list_comport
      # variables internes
      self._nb_vari  = meta.nb_vari * mat.nb_vari + meta.nb_vari + 1
      self._nom_vari = []
      # variables internes pour chaque phase
      for phase in mat.nom_vari:
         for vari in meta.nom_vari:
            self._nom_vari.append('%s_%s' % (vari, phase))
      
      # si �crouissage isotrope, l'indicateur de plasticit� arrive avant !
      if meta.nb_vari == 1:
         self._nom_vari.append('INDICAT')
      
      # variables internes moyennes (�crouissage moyen)
      for vari in meta.nom_vari:
         self._nom_vari.append('%s_MOYEN' % vari)
      
      # si �crouissage cin�matique, l'indicateur de plasticit� arrive apr�s !
      if meta.nb_vari > 1:
         self._nom_vari.append('INDICAT')

      if len(self._nom_vari) != self._nb_vari:
         raise CataComportementError, "Nombre de variables internes = %d, incoh�rent avec la liste des variables internes %s" % (self._nb_vari, self._nom_vari)

# -----------------------------------------------------------------------------
   def get_nb_vari(self):
      return self._nb_vari or 0

   nb_vari = property(get_nb_vari, "nb_viru")

# -----------------------------------------------------------------------------
   def get_nom_vari(self):
      return self._nom_vari

   nom_vari = property(get_nom_vari, "nom_vari")


# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
class CataLoiComportement(object):
   """Catalogue de loi de comportement.
   Il s'agit juste d'un dictionnaire contenant les objets de type LoiComportement
   et quelques m�thodes d'interrogation.
   """
   
# -----------------------------------------------------------------------------
   def __init__(self):
      """Initialisations.
      """
      self._dico = {}
      # pour nommer les comportements
      self._name_num      = 0
      self._name_template = 'COMP%012d'     # 16 caract�res
      self.debug = False

# -----------------------------------------------------------------------------
   def _name(self):
      """Retourne un nom de comportement (K16).
      """
      self._name_num += 1
      return self._name_template % self._name_num

# -----------------------------------------------------------------------------
   def add(self, comport):
      """Ajoute une loi de comportement au catalogue.
      """
      loi = comport.nom
      if self._dico.get(loi) is not None:
         raise CataComportementError, 'Comportement d�j� d�fini : %s' % loi
      self._dico[loi] = comport

# -----------------------------------------------------------------------------
   def get(self, loi):
      """Retourne l'objet LoiComportement dont le nom est 'loi'.
      """
      comport = self._dico.get(loi.strip())
      if comport is None:
         raise CataComportementError, 'Comportement inexistant : %s' % loi
      return comport

# -----------------------------------------------------------------------------
   def create(self, *list_kit):
      """Cr�er un assemblage de LC compos� des comportements list�s dans 'list_kit'
      et retourne le nom attribu� automatiquement � ce comportement.
      
      CALL LCCREE(NBKIT, LKIT, COMPOR)
      ==> comport = catalc.create(*list_kit)
      """
      if self.debug:
         print 'catalc.create - args =', list_kit
      nom = self._name()
      list_comport = [self.get(kit) for kit in list_kit]
      comport = KIT(nom, *list_comport)
      self.add(comport)
      return nom

# -----------------------------------------------------------------------------
   def get_info(self, loi):
      """Retourne le num�ro de routine et le nbre de variables internes
      
      CALL LCINFO(COMPOR, NUMLC, NBVARI)
      ==> num_lc, nb_vari = catalc.get_info(COMPOR)
      """
      if self.debug:
         print 'catalc.get_info - args =', loi
      comport = self.get(loi)
      return comport.num_lc, comport.nb_vari

# -----------------------------------------------------------------------------
   def get_vari(self, loi):
      """Retourne la liste des variables internes
      
      CALL LCVARI(COMPOR, NBVARI, LVARI)
      ==> nom_vari = catalc.get_vari(COMPOR)
      """
      if self.debug:
         print 'catalc.get_vari - args =', loi
      comport = self.get(loi)
      return comport.nom_vari

# -----------------------------------------------------------------------------
   def query(self, loi, attr, valeur):
      """Est-ce que VALEUR est un valeur autoris�e de PROPRIETE ?
         CALL LCTEST(COMPOR, PROPRIETE, VALEUR, IRET)
         ==> iret = catalc.query(COMPOR, PROPRIETE, VALEUR)
      """
      if self.debug:
         print 'catalc.query - args =', loi, ':', attr, ':', valeur.strip(),':'
      attr = attr.lower()
      comport = self.get(loi)
      if not attr in __properties__:
         raise CataComportementError, 'Propriete invalide : %s' % attr
      # retourner 1 si (valeur est dans comport.attr), 0 sinon.
      return int(valeur.strip() in getattr(comport, attr))

# -----------------------------------------------------------------------------
   def get_algo(self, loi):
      """Retourne le 1er algorithme d'integration
      
      CALL LCALGO(COMPOR, ALGO)
      ==> algo_inte = catalc.get_algo(COMPOR)
      """
      if self.debug:
         print 'catalc.get_algo - args =', loi
      comport = self.get(loi)
      return comport.algo_inte

# -----------------------------------------------------------------------------
   def __repr__(self):
      """Repr�sentation du catalogue.
      """
      sep = '-'*90
      txt = [sep]
      for k in self._dico.keys():
         txt.append(repr(self.get(k)))
         txt.append(sep)
      return os.linesep.join(txt)

# -----------------------------------------------------------------------------
# instance unique du catalogue
catalc = CataLoiComportement()




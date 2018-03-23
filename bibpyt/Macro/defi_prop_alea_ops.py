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

# person_in_charge: irmela.zentner at edf.fr


"""Commande DEFI_PROP_ALEA"""

import sys
import traceback

from math import pi, ceil, exp, sqrt, log
import numpy as np
import pickle
import aster_core
from code_aster.Cata.Commands import FORMULE
from Utilitai.Utmess import UTMESS

def defi_prop_alea_ops(self, **kwargs):
    """Corps de la macro DEFI_PROP_ALEA"""
    self.set_icmd(1)
    ier = 0
    # conteneur des paramètres du calcul
    params = Randomfield(**kwargs)
    np.random.seed(params.seed)     
    # création de l'objet generator
    generator = Generator.factory(self, params)
    try:
        generator.run()
    except Exception, err:
        trace = ''.join(traceback.format_tb(sys.exc_traceback))
        UTMESS('F', 'SUPERVIS2_5', valk=('DEFI_PROP_ALEA', trace, str(err)))



def evaluate_KL1D(X1, DIM, RANGE, XLISTE, Ux, beta, mediane, pseed ):
        np.random.seed(pseed)
        x1 = (X1 - RANGE[0][0]) / DIM[0]
        U1 = [np.interp(x1, XLISTE[0], term)  for term in Ux[0]]
        Ux_1 = mediane * np.exp(beta*sum([ u1 * np.random.normal(0.0, 1.)  for u1 in U1 ]))
        return Ux_1


def evaluate_KL2D(X1, X2, DIM, RANGE, XLISTE, Ux, beta, mediane, pseed ):
        np.random.seed(pseed)
        x1 = (X1 - RANGE[0][0]) / DIM[0]
        x2 = (X2 - RANGE[1][0]) / DIM[1]
        U1 = [np.interp(x1, XLISTE[0], term)  for term in Ux[0]]
        U2 = [np.interp(x2, XLISTE[1], term)  for term in Ux[1]]
        Ux_12 = mediane * np.exp(beta*sum([ u1 * u2 * np.random.normal(0.0, 1.)  for u1 in U1  for u2 in U2]))
        return Ux_12


def evaluate_KL3D(X1, X2, X3, DIM, RANGE, XLISTE, Ux, beta, mediane, pseed ):
        np.random.seed(pseed)
        x1 = (X1 - RANGE[0][0]) / DIM[0]
        x2 = (X2 - RANGE[1][0]) / DIM[1]
        x3 = (X3 - RANGE[2][0]) / DIM[2]
        U1 = [np.interp(x1, XLISTE[0], term)  for term in Ux[0]]
        U2 = [np.interp(x2, XLISTE[1], term)  for term in Ux[1]]
        U3 = [np.interp(x3, XLISTE[2], term)  for term in Ux[2]]
        Ux_123 = mediane * np.exp(beta*sum([ u1 * u2 * u3 * np.random.normal(0.0, 1.)     for u1 in U1  for u2 in U2  for u3 in U3]))
        return Ux_123



class Randomfield(object):

    def __init__(self, **kwargs):
        """Enregistrement des valeurs des mots-clés dans un dictionnaire.
        """
        # GeneralKeys
        self.args = kwargs
        self.seed = kwargs.get('INIT_ALEA')
        self.mediane = kwargs.get('MEDIANE')
        self.beta = kwargs.get('COEF_VARI')
        self.cas =  None
        cdict = {'RANGE': [] ,    'NBTERMS' : [], 'DIM' : [],
                       'LONG_CORR' : [],  'COORD' : None, 'XLISTE' : []}
        # XYZKeys
        liste_coord = []
        if  kwargs.get('LONG_CORR_X') != None:
            self.dimx = kwargs.get('X_MAXI')-kwargs.get('X_MINI')
            self.Lcx = kwargs.get('LONG_CORR_X')
            cdict['RANGE'].append((kwargs.get('X_MINI'), kwargs.get('X_MAXI')))
            cdict['NBTERMS'].append(kwargs.get('NB_TERM_X'))
            cdict['DIM'].append(self.dimx)
            cdict['LONG_CORR'].append(self.Lcx)
            xliste = np.arange(0, 1.+ self.Lcx/self.dimx/100., self.Lcx/self.dimx/100.)
            cdict['XLISTE'].append(xliste)
            liste_coord.append('X')

        if  kwargs.get('LONG_CORR_Y') != None:
            self.dimy = kwargs.get('Y_MAXI')-kwargs.get('Y_MINI')
            self.Lcy = kwargs.get('LONG_CORR_Y')
            cdict['RANGE'].append((kwargs.get('Y_MINI'), kwargs.get('Y_MAXI')))
            cdict['NBTERMS'].append(kwargs.get('NB_TERM_Y'))
            cdict['DIM'].append(self.dimy)
            cdict['LONG_CORR'].append(self.Lcy)
            yliste = np.arange(0, 1.+ self.Lcy/self.dimy/100., self.Lcy/self.dimy/100.)
            cdict['XLISTE'].append(yliste)
            liste_coord.append('Y')

        if  kwargs.get('LONG_CORR_Z') != None:
            self.dimz = kwargs.get('Z_MAXI')-kwargs.get('Z_MINI')
            self.Lcz = kwargs.get('LONG_CORR_Z')
            cdict['RANGE'].append((kwargs.get('Z_MINI'), kwargs.get('Z_MAXI')))
            cdict['NBTERMS'].append(kwargs.get('NB_TERM_Z'))
            cdict['DIM'].append(self.dimz)
            cdict['LONG_CORR'].append(self.Lcz)
            zliste = np.arange(0, 1.+ self.Lcz/self.dimz/100., self.Lcz/self.dimz/100.)
            cdict['XLISTE'].append(zliste)
            liste_coord.append('Z')

        cdict['COORD'] = liste_coord
        self.coord = liste_coord
        self.cas = str(len(liste_coord)) + 'D'
        self.data = cdict
        if len(liste_coord) > 3:
            raise ValueError('unknown configuration')
 
          
class Generator(object):

    """Base class Generator"""

    @staticmethod
    def factory(macro, params):
        """create an instance of the appropriated type of Generator"""
        if params.cas == '1D':
            return Generator1(macro, params)
        elif params.cas == '2D':
            return Generator2(macro, params)
        elif params.cas == '3D':
            return Generator3(macro, params)
        else:
            raise ValueError('unknown configuration')

    def __init__(self, macro, params):
        """Constructor Base class"""
        self.name = macro.sd.nom
        self.macro = macro
        self.mediane = params.mediane
        self.cas = params.cas
        self.data = params.data
        self.mediane = params.mediane
        self.beta = params.beta
        self.seed = params.seed
        self.coord = params.coord
#        self.formule  = formule(titr='GENE_PROP_ALEA concept : %s' % macro.sd.nom)

    def compute_KL(self):
        """specific to each method"""
        raise NotImplementedError('must be implemented in a subclass')


    def is_even(self, num):
        """Return whether the number num is even."""
        return num % 2 == 0

    def find_roots(self, x, vecf):
        roots = []
        signum = np.sign(vecf)
        for (ii, vale) in enumerate(signum):
            if ii==0:
                pass
            elif vale != signum[ii-1]:
                pos = (x[ii] - x[ii-1]) * 0.5 + x[ii-1]
                roots.append(pos)
        return roots

    def eval_eigfunc(self, x, Lc , nbmod):
        v = np.arange(1.0, 200., 0.01)
        veck = [  (1- Lc * vale * np.tan(0.5*vale)) * (Lc * vale + np.tan(0.5*vale))    for vale in v]
        troots = self.find_roots(v, veck)
        roots = troots[:nbmod]
        lamk = 2. * Lc * (1. + np.array(roots)**2 * Lc**2)**(-1)
        print 'NUMBER of ROOTS:', len(troots), 'RETAINED ', nbmod  , 'EIGENVALUES :', lamk
        phik =[]
        for (ii, vk) in enumerate(roots):
            if self.is_even(ii): # %even
                phik.append( np.cos(vk * (x - 0.5)) / np.sqrt(0.5 * (1. + np.sin(vk) / vk)) )
            else:          # %odd
                phik.append( np.sin(vk * (x - 0.5)) / np.sqrt(0.5 * (1. - np.sin(vk) / vk )) )
        return zip(lamk, phik)


class Generator1(Generator):

    """1D class"""

    def compute_KL(self):
        Lcx1 = self.data['LONG_CORR'][0]
        dimx1 = self.data['DIM'][0]
        nbmod1 = int(self.data['NBTERMS'][0])
        KL_data1  = self.eval_eigfunc(self.data['XLISTE'][0], Lcx1/dimx1, nbmod1)
        self.Ux1 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data1 ]


    def run(self):
        self.compute_KL()
        self.macro.DeclareOut('formule_out', self.macro.sd)
        data = {'user_func': evaluate_KL1D, 'XLISTE': self.data['XLISTE'],
                'DIM': self.data['DIM'],  'RANGE': self.data['RANGE'], 'Ux' : (self.Ux1,),
                'mediane':  self.mediane , 'beta' : self.beta, 'seed': self.seed }
        if self.coord == ['X']:
            formule_out = FORMULE(NOM_PARA=('X'), VALE="user_func(X,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        elif self.coord == ['Y']:
            formule_out = FORMULE(NOM_PARA=('Y'), VALE="user_func(Y,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        elif self.coord == ['Z']:
            formule_out = FORMULE(NOM_PARA=('Z'), VALE="user_func(Z,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        else:
            raise ValueError('unknown configuration')
        formule_out.set_context(pickle.dumps(data))



class Generator2(Generator):

    """2D class"""

    def compute_KL(self ):
        Lcx1 = self.data['LONG_CORR'][0]
        Lcx2 = self.data['LONG_CORR'][1]
        dimx1 = self.data['DIM'][0]
        dimx2 = self.data['DIM'][1]
        nbmod1 = int(self.data['NBTERMS'][0])
        nbmod2 = int(self.data['NBTERMS'][1])

        KL_data1  = self.eval_eigfunc(self.data['XLISTE'][0], Lcx1/dimx1, nbmod1)
        self.Ux1 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data1 ]

        KL_data2  = self.eval_eigfunc(self.data['XLISTE'][1], Lcx2/dimx2, nbmod2)
        self.Ux2 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data2 ]


    def run(self):
        self.compute_KL()
        self.macro.DeclareOut('formule_out', self.macro.sd)
        data = {'user_func': evaluate_KL2D, 'XLISTE': self.data['XLISTE'],
                'DIM': self.data['DIM'],  'RANGE': self.data['RANGE'], 'Ux' : (self.Ux1, self.Ux2),
                'mediane':  self.mediane , 'beta' : self.beta, 'seed': self.seed }
        print 'X,Y', self.coord
        if self.coord == ['X','Y']:
            formule_out = FORMULE(NOM_PARA= ('X','Y'), VALE="user_func(X,Y,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        elif self.coord == ['X','Z']:
            formule_out = FORMULE(NOM_PARA= ('X','Z'), VALE="user_func(X,Z,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        elif self.coord == ['Y','Z']:
            formule_out = FORMULE(NOM_PARA= ('Y','Z'), VALE="user_func(Y,Z,DIM,RANGE,XLISTE,Ux,beta,mediane, seed)" )
        else:
            raise ValueError('unknown configuration')
        formule_out.set_context(pickle.dumps(data))




class Generator3(Generator):

    """3D class"""

    def compute_KL(self): 
        Lcx1 = self.data['LONG_CORR'][0]
        Lcx2 = self.data['LONG_CORR'][1]
        Lcx3 = self.data['LONG_CORR'][2]
        dimx1 = self.data['DIM'][0]
        dimx2 = self.data['DIM'][1]
        dimx3 = self.data['DIM'][2]
        nbmod1 = int(self.data['NBTERMS'][0])
        nbmod2 = int(self.data['NBTERMS'][1])
        nbmod3 = int(self.data['NBTERMS'][2])

        KL_data1  = self. eval_eigfunc(self.data['XLISTE'][0], 
                                Lcx1/dimx1, nbmod1)
        self.Ux1 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data1 ]

        KL_data2  = self.eval_eigfunc(self.data['XLISTE'][1], 
                                 Lcx2/dimx2, nbmod2)
        self.Ux2 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data2 ]

        KL_data3  = self.eval_eigfunc(self.data['XLISTE'][2], 
                                 Lcx3/dimx3, nbmod3)
        self.Ux3 = [ np.sqrt(leig) * np.array(veig)  for (leig, veig) in KL_data3 ]


    def run(self):
        self.compute_KL()
        self.macro.DeclareOut('formule_out', self.macro.sd)
        data = {'user_func': evaluate_KL3D, 'XLISTE': self.data['XLISTE'],
                'DIM': self.data['DIM'],  'RANGE': self.data['RANGE'], 'Ux' : (self.Ux1, self.Ux2 ,self.Ux3),
                'mediane':  self.mediane , 'beta' : self.beta, 'seed': self.seed }
        formule_out = FORMULE(NOM_PARA=('X', 'Y', 'Z'), VALE="user_func(X, Y, Z, DIM, RANGE, XLISTE, Ux, beta, mediane, seed)" )
        formule_out.set_context(pickle.dumps(data))


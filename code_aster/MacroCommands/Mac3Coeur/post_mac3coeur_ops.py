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

# person_in_charge: francesco.bettonte at edf.fr
import os.path as osp
from math import sqrt

import numpy as np
import numpy.linalg as LA

import aster

from ...Cata.Syntax import _F
from ...Commands import CALC_TABLE, CREA_TABLE, FORMULE, IMPR_TABLE
from ...Helpers.UniteAster import UniteAster
from ...Messages import UTMESS
from ...Objects.table_py import Table
from ...Utilities import ExecutionParameter
from .mac3coeur_coeur import CoeurFactory

UL=UniteAster()

round_post = lambda s : round(s,4)

def NodePos(coeur,k):
    return coeur.get_XYOut('%s_%s'%(k[0],k[1]))

def makeXMGRACE_entete(coeur,xmgrfile) :
    length   = coeur.get_length()
    xmgrfile.write('@focus on\n@g0 on\n@with g0\n')
    xmgrfile.write('@VIEW 0.1,0.1,0.85,0.85\n')
    for val_abs in range(0, length):
        xmgrfile.write('@with string\n@string on\n@string loctype world\n@string color '
                       '(0,0,0)\n@string char size 0.8\n@string just 2\n@string %f, %f\n'
                       '@string def \"%s\"\n'
                       % (val_abs - (length - 1) / 2., (length - 1) / 2. + 1.2,
                          coeur.get_enumerateOut_X(val_abs)))
    for val_ord in range(0, length):
        xmgrfile.write('@with string\n@string on\n@string loctype world\n@string color (0,0,0)\n'
                       '@string char size 0.8\n@string just 2\n@string %f, %f\n'
                       '@string def \"%s\"\n'
                       % (-(length - 1) / 2. - 1.5,  val_ord - (length - 1) / 2. - 0.2,
                          coeur.get_enumerateOut_Y(val_ord)))
    xmgrfile.write('@kill s0\n@s0 line pattern 0\n@s0 symbol fill pattern 0\n%f %f\n%f %f\n'
                   % (-(length - 1) / 2. - 1.02, -(length - 1) / 2. - 0.4,
                      (length - 1) / 2. + 0.5, (length - 1) / 2. + 1.05))

def makeXMGRACEjeu(unit, post, coeur, valjeuac, valjeucu):
    def computeColor(value):
        valmin = 0.
        valmax = 0.7
        if (value <= valmin):
            redF = 255
            greenF = 0
            blueF = 0
            lame = 'c'
            size = 0.8
        elif (value > valmax):
            redF = 0
            greenF = 0
            blueF = 0
            lame = '%.1f' % value
            size = 0.6
        else:
            redF = 0
            greenF = 0
            blueF = 255
            lame = '%.1f' % value
            size = 0.6

        return (redF, greenF, blueF, lame, size)


    def NodePosCu(position):
        #x = 0.
        #y = 0.
        #if (position == 'W'):
            #x = -0.5
        #elif (position == 'N'):
            #y = -0.5
        #elif (position == 'E'):
            #x = +0.5
        #elif (position == 'S'):
            #y = +0.5

        (x,y) = coeur.get_bordXY(position)

        return (x, y)

    POSITION = coeur.get_geom_coeur()

    #filename = './fort.%d' % (unit)
    filename = UL.Nom(unit)

    xmgrfile = open(filename, 'w')

    makeXMGRACE_entete(coeur,xmgrfile)

    ind = 0
    for k in POSITION:
        ind = ind + 1
        (x,y) = NodePos(coeur,k)
        #print '(x,y) = ',x,y
        xmgrfile.write('@kill s%d\n@s%d symbol 2\n@s%d symbol pattern 1\n@s%d symbol size 0.4\n'
                       '@s%d symbol color 1\n@s%d symbol fill pattern 1\n@s%d symbol fill color 1\n'
                       '@type xy\n%10.8f %10.8f\n' % (ind, ind, ind, ind, ind, ind, ind, x, y))

    for name in list(valjeucu.keys()):
        position1 = name[3:5]
        position2 = name[6:7]
        #print 'position 1 = ',position1
        #print 'position 2 = ',position2
        (x1, y1) = NodePos(coeur,position1)
        (x2, y2) = NodePosCu(position2)
        if (post == 'MAXI'):
            (redF, greenF, blueF, lame, size) = computeColor(
                max(valjeucu[name]))
            titre = 'maximaux'
        elif (post == 'MINI'):
            (redF, greenF, blueF, lame, size) = computeColor(
                min(valjeucu[name]))
            titre = 'minimaux'
        else:
            (redF, greenF, blueF, lame, size) = computeColor(
                valjeucu[name][post - 1])
            titre = 'au niveau des grilles %s' % post
        xmgrfile.write('@with string\n@string on\n@string loctype world\n'
                       '@string color (%d,%d,%d)\n@string char size %f\n@string just 2\n@string %f, %f\n'
                       '@string def \"%s\"\n' % (redF, greenF, blueF, size, (x1 + x2), (y1 + y2) - 0.1, lame))

    if len(valjeuac) != 0:
        for name in list(valjeuac.keys()):
            position1 = name[4:6]
            position2 = name[6:8]
            (x1, y1) = NodePos(coeur,position1)
            (x2, y2) = NodePos(coeur,position2)
            if (post == 'MAXI'):
                (redF, greenF, blueF, lame, size) = computeColor(
                    max(valjeuac[name]))
            elif (post == 'MINI'):
                (redF, greenF, blueF, lame, size) = computeColor(
                    min(valjeuac[name]))
            else:
                (redF, greenF, blueF, lame, size) = computeColor(
                    valjeuac[name][post - 1])
            xmgrfile.write('@with string\n@string on\n@string loctype world\n'
                           '@string color (%d,%d,%d)\n@string char size %f\n@string just 2\n@string %f, %f\n'
                           '@string def \"%s\"\n' % (redF, greenF, blueF, size, (x1 + x2) / 2.0, (y1 + y2) / 2.0 - 0.1, lame))

    xmgrfile.write('&\n@xaxis ticklabel off\n@yaxis ticklabel off\n@xaxis tick off\n'
                   '@yaxis tick off\n@subtitle \"Jeux %s entre les ACs du Coeur (en mm)"\n'
                   '@DEVICE \"JPEG\" PAGE SIZE 1200,1200\n@autoscale\n@redraw\n' % (titre))
    xmgrfile.close()


def makeXMGRACEdef_amp(unit, post, coeur, valdefac):

    def computeColor(value):
        if (value <= 10.):
            redF = 0
            greenF = 255 * value / 10
            blueF = 255 * (1 - value / 10)
            size = value / 20.
        elif (value <= 20.):
            redF = 255 * (value - 10) / 10
            greenF = 255 * (1 - (value - 10) / 10)
            blueF = 0
            size = value / 20.
        else:
            redF = 0
            greenF = 0
            blueF = 0
            size = 1.0

        return (redF, greenF, blueF, size)

    #filename = './fort.%d' % (unit)
    filename = UL.Nom(unit)

    xmgrfile = open(filename, 'w')
    makeXMGRACE_entete(coeur,xmgrfile)
    ind = 0
    for name in list(valdefac.keys()):
        ind = ind + 1
        position = name[0:3]
        #print 'position = ',position
        (x,y) = coeur.get_XYOut(position)
        if (post == 'MAXI'):
            (redF, greenF, blueF, size) = computeColor(max(valdefac[name]))
            titre = 'maximale'
        elif (post == 'MINI'):
            (redF, greenF, blueF, size) = computeColor(min(valdefac[name]))
            titre = 'minimale'
        else:
            (redF, greenF, blueF, size) = computeColor(
                valdefac[name][post - 1])
            titre = 'au niveau des grilles %s' % post
        xmgrfile.write('@kill s%d\n@s%d symbol fill pattern %d\n'
                       '@s%d symbol fill color (%d, %d, %d)\n@s%d symbol 1\n@s%d symbol size %f\n'
                       '@s%d symbol color (%d, %d, %d)\n%d %d\n' % (ind, ind, 1, ind, redF, greenF, blueF, ind,
                                                                    ind, 2. * size, ind, redF, greenF, blueF, x, y))

    xmgrfile.write('&\n@xaxis ticklabel off\n@yaxis ticklabel off\n@xaxis tick off\n'
                   '@yaxis tick off\n@subtitle \"Deformation residuelle %s entre les ACs du Coeur (en mm)"\n'
                   '@DEVICE \"JPEG\" PAGE SIZE 1200,1200\n@autoscale\n@redraw\n' % (titre))
    xmgrfile.close()


def makeXMGRACEdef_mod(unit, post, coeur, valdefac):
    def computeColor(value):
        redF = 0
        greenF = 0
        blueF = 0

        return (redF, greenF, blueF, value)

    filename = UL.Nom(unit)
    #filename = './fort.%d' % (unit)

    xmgrfile = open(filename, 'w')
    makeXMGRACE_entete(coeur,xmgrfile)
    ind = 0
    for name in list(valdefac.keys()):
        ind = ind + 1
        position = name[0:3]
        (x,y) = coeur.get_XYOut(position)
        if (post == 'MAXI'):
            (redF, greenF, blueF, value) = computeColor(max(valdefac[name]))
            titre = 'maximales'
        elif (post == 'MINI'):
            (redF, greenF, blueF, value) = computeColor(min(valdefac[name]))
            titre = 'minimales'
        else:
            (redF, greenF, blueF, value) = computeColor(
                valdefac[name][post - 1])
            titre = 'au niveau des grilles %s' % post
        xmgrfile.write('@kill s%d\n@s%d symbol 2\n@s%d symbol pattern 1\n@s%d symbol size 2\n'
                       '@s%d symbol color 1\n@s%d symbol fill pattern 1\n'
                       '@s%d symbol fill color (248,248,252)\n@type xy\n%10.8f %10.8f\n'
                       % (ind, ind, ind, ind, ind, ind, ind, x, y))
        xmgrfile.write('@with string\n@string on\n@string loctype world\n'
                       '@string color(%d,%d,%d)\n@string char size %f\n@string just 2\n@string %f, %f\n'
                       '@string def \"%10.1f\"\n' % (redF, greenF, blueF, 0.7, x - 0.37, y - 0.15, value))

    xmgrfile.write('&\n@xaxis ticklabel off\n@yaxis ticklabel off\n@xaxis tick off\n'
                   '@yaxis tick off\n@subtitle \"Module des deformations residuelles %s entre les ACs'
                   ' du Coeur (en mm)"\n@DEVICE \"JPEG\" PAGE SIZE 1200,1200\n@autoscale\n@redraw\n' % (titre))
    xmgrfile.close()


def makeXMGRACEdef_vec(unit, post, coeur, valdefac, valdirYac, valdirZac):

    outGraceXY = coeur.get_outGraceXY()

    def computeVector(value, Y, Z):
        Rvec = value / 20.

        vec = {'X' : Y / 20., 'Y' : Z / 20.}
        Xvec = vec[outGraceXY['X'][0]]*outGraceXY['X'][1]
        Yvec = vec[outGraceXY['Y'][0]]*outGraceXY['Y'][1]

        return (Xvec, Yvec, Rvec)

    #filename = './fort.%d' % (unit)
    filename = UL.Nom(unit)

    xmgrfile = open(filename, 'w')
    makeXMGRACE_entete(coeur,xmgrfile)
    ind = 0
    for name in list(valdefac.keys()):
        ind = ind + 1
        position = name[0:3]
        (x,y) = coeur.get_XYOut(position)
        if (post == 'MAXI'):
            pos = valdefac[name].index(max(valdefac[name]))
            (Xvec, Yvec, Rvec) = computeVector(
                valdefac[name][pos], valdirYac[name][pos], valdirZac[name][pos])
            titre = 'maximale'
        elif (post == 'MINI'):
            pos = valdefac[name].index(min(valdefac[name]))
            (Xvec, Yvec, Rvec) = computeVector(
                valdefac[name][pos], valdirYac[name][pos], valdirZac[name][pos])
            titre = 'minimale'
        else:
            (Xvec, Yvec, Rvec) = computeVector(
                valdefac[name][post - 1], valdirYac[name][post - 1], valdirZac[name][post - 1])
            titre = 'au niveau des grilles %s' % post
        xmgrfile.write('@kill s%d\n@s%d errorbar on\n@s%d errorbar color (%d, %d, %d)\n'
                       '@s%d errorbar place both\n@s%d errorbar pattern 1\n@s%d errorbar size %f\n'
                       '@s%d errorbar linewidth %f\n@s%d errorbar linestyle 1\n'
                       '@s%d errorbar riser linewidth %f\n@s%d errorbar riser clip off\n@type xyvmap\n'
                       '%d %d %10.8f %10.8f\n'
                       % (ind, ind, ind, 0, 0, 0, ind, ind, ind, 0.6 * Rvec, ind, 2.5 * Rvec, ind, ind, 2.5 * Rvec,
                          ind, x, y, 0.03 * Xvec, 0.03 * Yvec))

    xmgrfile.write('&\n@xaxis ticklabel off\n@yaxis ticklabel off\n@xaxis tick off\n'
                   '@yaxis tick off\n@subtitle \"Orientation des deformations %s entre les ACs'
                   ' du Coeur (en mm)"\n@DEVICE \"JPEG\" PAGE SIZE 1200,1200\n@autoscale\n@redraw\n' % (titre))
    xmgrfile.close()


def makeXMGRACEdeforme(unit, name, typeAC, coeur, valdefac):
    ac = coeur.factory.get(typeAC)(coeur.typ_coeur)
    filename = UL.Nom(unit)
    #filename = './fort.%d' % (unit)

    xmgrfile = open(filename, 'w')
    xmgrfile.write('@focus off\n@g0 on\n@with g0\n@kill s0\n@s0 symbol 9\n'
                   '@s0 symbol linewidth 3\n@s0 linewidth 3\n')
    xmgrfile.write('@VIEW 0.1,0.1,0.85,0.85\n')

    for k in range(0, len(ac.altitude)):
        xmgrfile.write('@with string\n@string on\n@string loctype world\n'
                       '@string color (0,50,120)\n@string char size %f\n@string just 2\n'
                       '@string %f, %f\n@string def \"%10.1f\"\n'
                       % (0.7, valdefac[name][k] + 1.0, ac.altitude[k] - 0.035, valdefac[name][k]))
    for k in range(0, len(ac.altitude)):
        xmgrfile.write('%10.8f %10.8f\n' % (valdefac[name][k], ac.altitude[k]))

    xmgrfile.write(
        '&\n@s2 on\n@with s2\n-20.0 -0.1\n&\n@s3 on\n@with s3\n20.0 4.6\n')
    xmgrfile.write('&\n@subtitle \"D\éform\ée de l\'assemblage %s (amplitudes (mm)/ha'
                   'uteur (m))"\n@DEVICE \"JPEG\" PAGE SIZE 1200,1200\n@autoscale\n@redraw\n' % (name))
    xmgrfile.close()

class CollectionPostAC():

    def __init__(self):
        self._collection = {}

        self.maxRho = 0.
        self.maxGravite = 0.
        self.locMaxRho = ''
        self.locMaxGravite = ''
        self.maxDeplGrille = [0.]*10
        self.locMaxDeplGrille = ['']*10
        self.moyenneRho = 0.
        self.moyenneGravite = 0.
        self.sigmaGravite = 0.
        self.maxGraviteParType = {}
        self.moyenneRhoParType = {}
        self.moyenneGraviteParType = {}
        
    def add(self, ac):
        self._collection[ac.get('PositionDAMAC')] = ac

    def get(self, pos):
        return self._collection[pos]

    def analyse(self, prec=1.e-8):
     
        for pos_damac in sorted(self._collection.keys()) : 
            AC = self.get(pos_damac)
            
            if AC.get('Rho') - self.maxRho > prec :
                self.maxRho = AC.get('Rho')
                self.locMaxRho = pos_damac
                
            if AC.get('Gravite') - self.maxGravite > prec :
                self.maxGravite = AC.get('Gravite')
                self.locMaxGravite = pos_damac

            for g in range(AC.nb_grilles):
                if AC.get('NormF')[g] - self.maxDeplGrille[g] > prec:
                    self.maxDeplGrille[g] = AC.get('NormF')[g]
                    self.locMaxDeplGrille[g] = pos_damac
                    
        self.moyenneRho = np.mean(tuple(AC.get('Rho') for AC in self._collection.values()))
        self.moyenneGravite = np.mean(tuple(AC.get('Gravite') for AC in self._collection.values()))

        self.sigmaGravite = np.sqrt(np.mean((np.array(tuple(AC.get('Gravite') for AC in self._collection.values()))-self.moyenneGravite)**2))

        types = set((AC.get('TypeAC') for AC in self._collection.values()))
        self.maxRhoParType = {i : max((AC.get('Rho') for AC in self._collection.values() if i == AC.get('TypeAC'))) for i in types}
        self.maxGraviteParType = {i : max((AC.get('Gravite') for AC in self._collection.values() if i == AC.get('TypeAC'))) for i in types}
        self.moyenneRhoParType = {i : np.mean(tuple(AC.get('Rho') for AC in self._collection.values() if i == AC.get('TypeAC'))) for i in types}
        self.moyenneGraviteParType = {i : np.mean(tuple(AC.get('Gravite') for AC in self._collection.values() if i == AC.get('TypeAC'))) for i in types}

    def extr_table_fleche(self):

        listdic = [AC.get_fleche_props() for pos, AC in sorted(self._collection.items())]
        listpara, listtype = PostAC.fleche_parameters_types()
        return Table(listdic,listpara,listtype)

    def extr_table_analyse(self):

        self.analyse()
        
        dico = {
            'moyRhoCoeur' : round_post(self.moyenneRho),
            'maxRhoCoeur' : round_post(self.maxRho),
            'moyGravCoeur' : round_post(self.moyenneGravite),
            'maxGravCoeur' : round_post(self.maxGravite),
            'sigGravCoeur' : round_post(self.sigmaGravite),
            'locMaxRho' : self.locMaxRho,
            'locMaxGrav' : self.locMaxGravite,
        }

        dico.update({'moR%s'%typ : round_post(value) for typ, value in self.moyenneRhoParType.items()})
        dico.update({'maR%s'%typ : round_post(value) for typ, value in self.maxRhoParType.items()})
        dico.update({'maG%s'%typ : round_post(value) for typ, value in self.maxGraviteParType.items()})
        dico.update({'moG%s'%typ : round_post(value) for typ, value in self.moyenneGraviteParType.items()})
        dico.update({'locMaxDeplG%i'%(i+1) : value for i, value in enumerate(self.locMaxDeplGrille) if value != ''})
        dico.update({'maxDeplGrille%i'%(i+1) : round_post(self.maxDeplGrille[i]) for i, value in enumerate(self.locMaxDeplGrille) if value != ''})

        print('table_post = ', dico)
        
        listpara = sorted(dico.keys())
        f = lambda s : 'K16' if s.startswith('loc') else 'R'
        listtype = [f(i) for i in listpara]
        
        return Table([dico],listpara,listtype)
    

class PostAC():
    
    def _compute_gravite(self, coor_x, fy, fz):

        K_star = 100000.
        sum_of_squared_sin = 0
        
        for i in range(1, len(coor_x)-1):
            gi_p = np.array((fy[i-1], fz[i-1], coor_x[i-1])) # previous grid
            gi_c = np.array((fy[i], fz[i], coor_x[i])) # current grid
            gi_n = np.array((fy[i+1], fz[i+1], coor_x[i+1])) # next grid
            
            squared_cos = np.dot(gi_c-gi_p, gi_n-gi_c)/(np.linalg.norm(gi_c-gi_p)*np.linalg.norm(gi_n-gi_c))
            sum_of_squared_sin += (1. - squared_cos)
            
        return K_star*sum_of_squared_sin

    def _compute_forme(self, fx, fy):
        crit = 500.0 #mm
        
        A1x = abs(min(fx))
        A2x = abs(max(fx))
        CCx = max(fx) - min(fx)
        shape_x = 'S' if (A1x > crit and A2x > crit) else 'C'
        
        A1y = abs(min(fy))
        A2y = abs(max(fy))
        CCy = max(fy) - min(fy)
        shape_y = 'S' if (A1y > crit and A2y > crit) else 'C'
        
        letters = ''.join(sorted(set((shape_x, shape_y))))
        shape_global = '2%s'%letters if len(letters) == 1 else letters
        
        return shape_x, shape_y, shape_global

    def get(self, kw):
        return self.props[kw]

    def __init__(self, coor_x, dy, dz, AC):

        fy = dy - dy[0] - (dy[-1] - dy[0])/(coor_x[-1] - coor_x[0])*(coor_x - coor_x[0])
        fz = dz - dz[0] - (dz[-1] - dz[0])/(coor_x[-1] - coor_x[0])*(coor_x - coor_x[0])
        FormeY, FormeZ, Forme = self._compute_forme(fy,fz)

        self.nb_grilles = len(coor_x)
        
        self.props = {
            'PositionDAMAC' : AC.idDAM,
            'PositionASTER' : AC.idAST,
            'Cycle' : AC._cycle,
            'Repere' : AC.name,
            'Rho' : max([np.sqrt((fy[i] - fy[j]) ** 2 + (fz[i] - fz[j]) ** 2)
                         for i in range(self.nb_grilles - 1) for j in range(i + 1, self.nb_grilles)]),
            'DepY' : dy[0] - dy[-1],
            'DepZ' : dz[0] - dz[-1],
            'TypeAC' : AC.typeAC,
            'MinY' : fy.min(),
            'MaxY' : fy.max(),
            'CCY' : fy.max() - fy.min(),
            'MinZ' : fz.min(),
            'MaxZ' : fz.max(),
            'CCZ' : fz.max() - fz.min(),
            'FormeY' : FormeY,
            'FormeZ' : FormeZ,
            'Forme' : Forme,
            'Gravite' : self._compute_gravite(coor_x, fy, fz),
            'NormF' : np.sqrt(fy**2+fz**2),
            'FY' : fy,
            'FZ' : fz,
        }
        
        self.props.update({'XG%d'%(i+1) : 0. for i in range(10)})
        self.props.update({'YG%d'%(i+1) : 0. for i in range(10)})
        
        self.props.update({'XG%d'%(i+1) : val for i, val in enumerate(fy)})
        self.props.update({'YG%d'%(i+1) : val for i, val in enumerate(fz)})
        
    def get_fleche_props(self):

        fleche_props = {
            'POS' : self.get('PositionDAMAC'),
            'Cycle' : self.get('Cycle'),
            'T5' : 0.,
            'T6' : 0.,
            'Repere' : self.get('Repere'),
            'Ro' : self.get('Rho'),
            'EinfXgg' : self.get('DepY'),
            'EinfYgg' : self.get('DepZ'),
            'Milieu' : self.get('TypeAC'),
            'Min X' : self.get('MinY'),
            'Max X' : self.get('MaxY'),
            'CC X' : self.get('CCY'),
            'Min Y' : self.get('MinZ'),
            'Max Y' : self.get('MaxZ'),
            'CC Y' : self.get('CCZ'),
            'Forme X' : self.get('FormeY'),
            'Forme Y' : self.get('FormeZ'),
            'Forme' : self.get('Forme'),
        }
        fleche_props.update({'XG%d'%(i+1) : self.get('XG%d'%(i+1)) for i in range(10)})
        fleche_props.update({'YG%d'%(i+1) : self.get('YG%d'%(i+1)) for i in range(10)})

        return fleche_props


    @staticmethod
    def fleche_parameters_types():

        para = ['POS', 'Cycle', 'T5', 'T6', 'Repere', 'Ro', 'EinfXgg', 'EinfYgg'] + \
               ['XG%d'%(d+1) for d in range(10)] + ['YG%d'%(d+1) for d in range(10)] + \
               ['Milieu', 'Min X', 'Max X', 'CC X', 'Min Y', 'Max Y', 'CC Y', 'Forme X', 'Forme Y', 'Forme']
        types = ['K8', 'I', 'R', 'R', 'K16', 'R', 'R', 'R'] + \
                ['R']*20 + \
                ['K16', 'R', 'R', 'R', 'R', 'R', 'R', 'K8', 'K8', 'K8']

        return para, types

def post_mac3coeur_ops(self, **args):
    """Corps principal de la macro de post-traitement de MAC3COEUR"""
    rcdir = ExecutionParameter().get_option("rcdir")
    datg = osp.join(rcdir, "datg")
    coeur_factory = CoeurFactory(datg)

    _RESU = args.get('RESULTAT')
    _typ_coeur = args.get('TYPE_COEUR')
    POST_LAME = args.get('LAME')
    POST_EFFORT = args.get('FORCE_CONTACT')
    POST_DEF = args.get('DEFORMATION')
    _inst = args.get('INST')
    _TAB_N = args.get('TABLE')
    if _typ_coeur[:5] == 'LIGNE' :
      _longueur = args.get('NB_ASSEMBLAGE')
    else :
      _longueur=None

    _table = _TAB_N.EXTR_TABLE()
    nameCoeur = _table.para[0]

    # et on renomme la colonne qui identifie les assemblages
    _table.Renomme(nameCoeur, 'idAC')
    _coeur = coeur_factory.get(_typ_coeur)(nameCoeur, _typ_coeur, self, datg,_longueur)
    _coeur.init_from_table(_table,mater=False)
    tableCreated = False

    # "
    #                                          MOT-CLE FACTEUR LAME
    # "

    if (POST_LAME is not None):

        valjeuac = {}
        valjeucu = {}
        post_table = 0
        for attr in POST_LAME:
            _typ_post = attr['FORMAT']
            if (_typ_post == 'TABLE'):
                post_table = 1

        _formule = FORMULE(NOM_PARA='V8', VALE='1000.*V8')

        # formule qui permet d'associer les COOR_X "presque" identiques (suite a
        # un calcul LAME)
        _indicat = FORMULE(NOM_PARA='COOR_X', VALE='int(10*COOR_X)')

        UTMESS('I', 'COEUR0_5')
        k = 0
        dim = len(_coeur.get_contactCuve())

        for name in _coeur.get_contactCuve() :

            _TAB2 = CREA_TABLE(
                RESU=_F(RESULTAT=_RESU,
                        NOM_CMP='V8',
                        GROUP_MA=name,
                        NOM_CHAM='VARI_ELGA',
                        INST=_inst,
                        PRECISION=1.E-08))

            _TAB2 = CALC_TABLE(reuse=_TAB2, TABLE=_TAB2,
                               ACTION=(
                               _F(OPERATION='FILTRE', NOM_PARA='POINT',
                                  CRIT_COMP='EQ', VALE_I=1),
                               _F(OPERATION='TRI', NOM_PARA='COOR_X',
                                  ORDRE='CROISSANT'),
                               _F(OPERATION='OPER',
                                  FORMULE=_formule, NOM_PARA=name),
                               _F(OPERATION='OPER', FORMULE=_indicat,
                                  NOM_PARA='INDICAT'),
                               )
                               )

            if (post_table == 1):

                # a la premiere occurence, on cree la table qui sera imprimee
                # (_TAB3), sinon, on concatene les tables
                if k == 0:
                    _TAB3 = CALC_TABLE(TABLE=_TAB2,
                                       ACTION=(_F(OPERATION='EXTR', NOM_PARA=('COOR_X', 'INDICAT', name))))
                else:

                    _TABTMP = CALC_TABLE(TABLE=_TAB2,
                                         ACTION=(_F(OPERATION='EXTR', NOM_PARA=('INDICAT', name))))
                    _TAB3 = CALC_TABLE(TABLE=_TAB3,
                                       ACTION=(_F(OPERATION='COMB', TABLE=_TABTMP, NOM_PARA='INDICAT')))

            tab2 = _TAB2.EXTR_TABLE()
            tab2.Renomme(name, 'P_LAME')
            valjeucu[name] = tab2.P_LAME.values()
            k = k + 1

        UTMESS('I', 'COEUR0_4')
        k = 0
        dim = len(_coeur.get_contactAssLame())

        if dim != 0:
            for name in _coeur.get_contactAssLame():
                _TAB1 = CREA_TABLE(
                    RESU=_F(RESULTAT=_RESU,
                            NOM_CMP='V8',
                            GROUP_MA=name,
                            NOM_CHAM='VARI_ELGA',
                            INST=_inst,
                            PRECISION=1.E-08))
                
                _TAB1 = CALC_TABLE(reuse=_TAB1, TABLE=_TAB1,
                                   ACTION=(
                                   _F(OPERATION='FILTRE', NOM_PARA='POINT',
                                      CRIT_COMP='EQ', VALE_I=1),
                                   _F(OPERATION='TRI',
                                      NOM_PARA='COOR_X', ORDRE='CROISSANT'),
                                   _F(OPERATION='OPER',
                                      FORMULE=_formule, NOM_PARA=name),
                                   _F(OPERATION='OPER',
                                      FORMULE=_indicat, NOM_PARA='INDICAT'),
                                   )
                                   )
                if (post_table == 1):
                    _TABTMP = CALC_TABLE(TABLE=_TAB1,
                                         ACTION=(_F(OPERATION='EXTR', NOM_PARA=('INDICAT', name))))
                    _TAB3 = CALC_TABLE(TABLE=_TAB3,
                                       ACTION=(_F(OPERATION='COMB', TABLE=_TABTMP, NOM_PARA='INDICAT')))
                tab1 = _TAB1.EXTR_TABLE()
                tab1.Renomme(name, 'P_LAME')
                valjeuac[name] = tab1.P_LAME.values()
                k = k + 1

        valContactCuve = []
        valContactAssLame = []
        # pour table globale
        for name in _coeur.get_contactCuve() :
            valContactCuve.append(valjeucu[name])
        for name in _coeur.get_contactAssLame() :
            valContactAssLame.append(valjeuac[name])
        valContactCuve=np.array(valContactCuve)
        valContactAssLame=np.array(valContactAssLame)
        nb_grilles = valContactCuve.shape[1]
        valQuantile=[70,80,90,95,99]

        liste_out=[]

        for i in range(nb_grilles) :
            valContactCuveGrille    = valContactCuve[:,i]
            valContactAssLameGrille = valContactAssLame[:,i]
            valContactGrille        = valContactCuveGrille.tolist()
            valContactGrille.extend(valContactAssLameGrille)
            for quant in valQuantile :
                liste_out.append({
                    'LISTE_R' : round_post(np.percentile(valContactCuveGrille,quant)),
                    'PARA'    : 'QuanLE_CU_G%d_%d'%(i+1,quant)
                    })
                liste_out.append({
                    'LISTE_R' : round_post(np.percentile(valContactAssLameGrille,quant)),
                    'PARA'    : 'QuanLE_AC_G%d_%d'%(i+1,quant)
                    })
                liste_out.append({
                    'LISTE_R' : round_post(np.percentile(valContactGrille,quant)),
                    'PARA'    : 'QuanLE_G%d_%d'%(i+1,quant)
                    })
        valContact = valContactCuve.ravel().tolist()
        valContact.extend(valContactAssLame.ravel())
        for quant in valQuantile :
            liste_out.append({
                'LISTE_R' : round_post(np.percentile(valContactCuve.ravel(),quant)),
                'PARA'    : 'QuanLE_CU_%d'%(quant,)
                })
            liste_out.append({
                'LISTE_R' : round_post(np.percentile(valContactAssLame.ravel(),quant)),
                'PARA'    : 'QuanLE_AC_%d'%(quant,)
                })
            liste_out.append({
                'LISTE_R' : round_post(np.percentile(valContact,quant)),
                'PARA'    : 'QuanLE_%d'%(quant,)
                })


        __TAB_OUT = CREA_TABLE(TITRE='RESU_GLOB_'+nameCoeur,
                             LISTE=liste_out
                             )

        tableCreated = True

        for attr in POST_LAME:
            _unit = attr['UNITE']
            _typ_post = attr['FORMAT']

            #DEFI_FICHIER(ACTION='LIBERER', UNITE=_unit)

            if (_typ_post == 'GRACE'):

                _num_grille = attr['NUME_GRILLE']
                _extremum = attr['TYPE_RESU']

                if (_extremum is None):
                    post = _num_grille
                else:
                    post = _extremum

                makeXMGRACEjeu(_unit, post, _coeur, valjeuac, valjeucu)

            elif (_typ_post == 'TABLE'):

                # liste des parametres a afficher (dans l'ordre)
                # Rq : on affiche la premiere occurence de 'COOR_X'
                l_para = ['COOR_X', ] + \
                    _coeur.get_contactAssLame() + _coeur.get_contactCuve()

                IMPR_TABLE(UNITE=_unit, TABLE=_TAB3, NOM_PARA=l_para,FORMAT_R='E12.6',)

    # "
    #                                          MOT-CLE FACTEUR FORCE_CONTACT
    # "

    if (POST_EFFORT is not None):

        valeffortac = {}
        valeffortcu = {}
        post_table = 0
        for attr in POST_EFFORT:
            _typ_post = attr['FORMAT']
            if (_typ_post == 'TABLE'):
                post_table = 1

        _formule = FORMULE(NOM_PARA='N', VALE='abs(1.*N)')

        # formule qui permet d'associer les COOR_X "presque" identiques (suite a
        # un calcul LAME)
        _indicat = FORMULE(NOM_PARA='COOR_X', VALE='int(10*COOR_X)')

        UTMESS('I', 'COEUR0_9')
        k = 0
        dim = len(_coeur.get_contactCuve())

        for name in _coeur.get_contactCuve() :

            _TAB2 = CREA_TABLE(
                RESU=_F(RESULTAT=_RESU,
                        NOM_CMP='N',
                        GROUP_MA=name,
                        NOM_CHAM='SIEF_ELGA',
                        INST=_inst,
                        PRECISION=1.E-08))

            _TAB2 = CALC_TABLE(reuse=_TAB2, TABLE=_TAB2,
                               ACTION=(
                               _F(OPERATION='FILTRE', NOM_PARA='POINT',
                                  CRIT_COMP='EQ', VALE_I=1),
                               _F(OPERATION='TRI', NOM_PARA='COOR_X',
                                  ORDRE='CROISSANT'),
                               _F(OPERATION='OPER',
                                  FORMULE=_formule, NOM_PARA=name),
                               _F(OPERATION='OPER', FORMULE=_indicat,
                                  NOM_PARA='INDICAT'),
                               )
                               )

            if (post_table == 1):

                # a la premiere occurence, on cree la table qui sera imprimee
                # (_TAB3), sinon, on concatene les tables
                if k == 0:
                    _TAB3 = CALC_TABLE(TABLE=_TAB2,
                                       ACTION=(_F(OPERATION='EXTR', NOM_PARA=('COOR_X', 'INDICAT', name))))
                else:

                    _TABTMP = CALC_TABLE(TABLE=_TAB2,
                                         ACTION=(_F(OPERATION='EXTR', NOM_PARA=('INDICAT', name))))
                    _TAB3 = CALC_TABLE(TABLE=_TAB3,
                                       ACTION=(_F(OPERATION='COMB', TABLE=_TABTMP, NOM_PARA='INDICAT')))

            tab2 = _TAB2.EXTR_TABLE()
            tab2.Renomme(name, 'P_EFFORT')
            valeffortcu[name] = tab2.P_EFFORT.values()
            k = k + 1

        UTMESS('I', 'COEUR0_8')
        k = 0
        dim = len(_coeur.get_contactAssLame())

        if dim != 0:
            for name in _coeur.get_contactAssLame():
                _TAB1 = CREA_TABLE(
                    RESU=_F(RESULTAT=_RESU,
                            NOM_CMP='N',
                            GROUP_MA=name,
                            NOM_CHAM='SIEF_ELGA',
                            INST=_inst,
                            PRECISION=1.E-08,))

                _TAB1 = CALC_TABLE(reuse=_TAB1, TABLE=_TAB1,
                                   ACTION=(
                                   _F(OPERATION='FILTRE', NOM_PARA='POINT',
                                      CRIT_COMP='EQ', VALE_I=1),
                                   _F(OPERATION='TRI',
                                      NOM_PARA='COOR_X', ORDRE='CROISSANT'),
                                   _F(OPERATION='OPER',
                                      FORMULE=_formule, NOM_PARA=name),
                                   _F(OPERATION='OPER',
                                      FORMULE=_indicat, NOM_PARA='INDICAT'),
                                   )
                                   )
                if (post_table == 1):
                    _TABTMP = CALC_TABLE(TABLE=_TAB1,
                                         ACTION=(_F(OPERATION='EXTR', NOM_PARA=('INDICAT', name))))
                    _TAB3 = CALC_TABLE(TABLE=_TAB3,
                                       ACTION=(_F(OPERATION='COMB', TABLE=_TABTMP, NOM_PARA='INDICAT')))
                tab1 = _TAB1.EXTR_TABLE()
                tab1.Renomme(name, 'P_EFFORT')
                valeffortac[name] = tab1.P_EFFORT.values()
                k = k + 1



        for attr in POST_EFFORT:
            _unit = attr['UNITE']
            _typ_post = attr['FORMAT']

            if (_typ_post == 'TABLE'):

                # liste des parametres a afficher (dans l'ordre)
                # Rq : on affiche la premiere occurence de 'COOR_X'
                l_para = ['COOR_X', ] + \
                    _coeur.get_contactAssLame() + _coeur.get_contactCuve()

                IMPR_TABLE(UNITE=_unit, TABLE=_TAB3, NOM_PARA=l_para,FORMAT_R='E12.6',)

        # FIXME to be fixed by issue29787
        __TAB_OUT = CREA_TABLE(TITRE='BIDON',
                               LISTE=(_F(LISTE_R=(0., 0.), PARA='BIDON')))

    # "
    #                                          MOT-CLE FACTEUR DEFORMATION
    # "
    if (POST_DEF is not None):

        UTMESS('I', 'COEUR0_6')

        post_coeur = CollectionPostAC()
        for AC in _coeur.collAC.values():
            
            _TAB1 = CREA_TABLE(RESU=_F(RESULTAT=_RESU,
                                       NOM_CMP=('DY', 'DZ'),
                                       GROUP_MA='GR_%s'%AC.idAST,
                                       NOM_CHAM='DEPL',
                                       INST=_inst,
                                       PRECISION=1.E-08))
            # Extraction des valeurs
            vals = np.stack((_TAB1.EXTR_TABLE().values()[i] for i in ('COOR_X', 'DY', 'DZ')))
            
            # Moyenne sur les 4 discrets de la grille (qui portent tous la meme valeur)
            vals = np.mean(vals.reshape(vals.shape[0], vals.shape[1]//4, 4),axis=2)
            # Passage en mm et arrondi
            coor_x, dy, dz = np.around(1000.0*vals[:, vals[0].argsort()],12)

            post_coeur.add(PostAC(coor_x, dy, dz, AC))
            
        table_analyse = post_coeur.extr_table_analyse()
        motcles = table_analyse.dict_CREA_TABLE()
        
        if not tableCreated: 
            __TAB_OUT = CREA_TABLE(**motcles)

        else :
            _TAB_A = CREA_TABLE(**motcles)
            __TAB_OUT = CALC_TABLE(reuse=__TAB_OUT,
                                   TABLE=__TAB_OUT,
                                   ACTION=_F(OPERATION='COMB',TABLE=_TAB_A))

        for attr in POST_DEF:
            _unit = attr['UNITE']
            _typ_post = attr['FORMAT']
            
            if (_typ_post == 'GRACE'):
                
                _num_grille = attr['NUME_GRILLE']
                _extremum = attr['TYPE_RESU']
                _autre = attr['TYPE_VISU']

                if (_extremum is None):
                    post = _num_grille
                else:
                    post = _extremum

                valdefac = {AC.get('PositionASTER') : list(AC.get('NormF')) for AC in post_coeur._collection.values()}
                valdirYac = {AC.get('PositionASTER') : list(AC.get('FY')) for AC in post_coeur._collection.values()}
                valdirZac = {AC.get('PositionASTER') : list(AC.get('FZ')) for AC in post_coeur._collection.values()}
                
                if (_autre == 'AMPLITUDE'):
                    makeXMGRACEdef_amp(_unit, post, _coeur, valdefac)
                elif (_autre == 'MODULE'):
                    makeXMGRACEdef_mod(_unit, post, _coeur, valdefac)
                elif (_autre == 'VECTEUR'):
                    makeXMGRACEdef_vec(
                        _unit, post, _coeur, valdefac, valdirYac, valdirZac)
                elif (_autre == 'DEFORME'):
                    name = attr['POSITION']
                    typeAC = attr['CONCEPTION']
                    makeXMGRACEdeforme(_unit, name, typeAC, _coeur, valdefac)

            elif (_typ_post == 'TABLE'):
                _format_standard = attr['FORMAT_R'] == 'STANDARD'
                _nom_site = attr['NOM_SITE']

                # creation de la table de sortie
                tab_extr = post_coeur.extr_table_fleche()
                tab_extr.Renomme('POS', _nom_site)
                tab_extr.titr = _typ_coeur
                motcles = tab_extr.dict_CREA_TABLE()
                _TABOUT = CREA_TABLE(**motcles)

                # impression de la table de sortie
                if _format_standard :
                    formt = 'E12.5'
                else :
                    formt = 'F5.1'
                IMPR_TABLE(TABLE=_TABOUT,
                           TITRE='---',
                           FORMAT_R=formt,
                           UNITE=_unit,
                           COMMENTAIRE='',
                           SEPARATEUR='\t',
                           FIN_LIGNE='\r\n',
                           )

    return __TAB_OUT

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

import os
import random
import string
import time
import types
from math import log, pi, factorial

import numpy as np

import aster
from code_aster.Cata.Syntax import _F
from Utilitai import partition
from Utilitai.UniteAster import UniteAster
from Utilitai.Utmess import UTMESS, MasquerAlarme, RetablirAlarme

#==============================================================================
def calc_bt_ops(self,
                RESU_BT,
                RESULTAT,
                INST,
                DDL_IMPO,
                FORCE_NODALE,
                BETON,
                ACIER,
                GROUP_MA_EXT,
                GROUP_MA_INT,
                SCHEMA,
                PAS_X,
                PAS_Y,
                TOLE_BASE,
                TOLE_BT,
                NMAX_ITER,
                RESI_RELA_TOPO,
                RESI_RELA_SECTION,
                CRIT_SECTION,
                CRIT_ELIM,
                SECTION_MINI,
                LONGUEUR_MAX,
                SIGMA_C,
                SIGMA_Y,
                INIT_ALEA,
                **args):
    """
       macro CALC_BT

    """
    # Code_ASTER command definitions
    DEFI_GROUP = self.get_cmd('DEFI_GROUP')
    AFFE_MODELE = self.get_cmd('AFFE_MODELE')
    AFFE_CARA_ELEM = self.get_cmd('AFFE_CARA_ELEM')
    AFFE_CHAR_MECA = self.get_cmd('AFFE_CHAR_MECA')
    MECA_STATIQUE = self.get_cmd('MECA_STATIQUE')
    CREA_GROUP_MA = self.get_cmd('CREA_GROUP_MA')
    AFFE_MATERIAU = self.get_cmd('AFFE_MATERIAU')
    CALC_CHAMP = self.get_cmd('CALC_CHAMP')
    CREA_TABLE = self.get_cmd('CREA_TABLE')
    CREA_CHAMP =  self.get_cmd('CREA_CHAMP')
    LIRE_MAILLAGE = self.get_cmd('LIRE_MAILLAGE')
    DETRUIRE = self.get_cmd('DETRUIRE')

    # La macro compte pour 1 dans la numerotation des commandes
    self.set_icmd(1)

    # Le concept sortant (de type table_sdaster) est nomme 'TABLE' dans le
    # contexte de la macro
    self.DeclareOut('TABLE', self.sd)
    self.DeclareOut('__resu', RESU_BT)

    #=========================================================================
    # Inputs
    #=========================================================================

    __GROUP_S = {}
    for __i in range(len(DDL_IMPO)):
        __current = DDL_IMPO[__i]
        __GROUP_S[__current['GROUP_NO']] = np.array([__current['DX'], __current['DY']])

    __GROUP_F = {}

    for __i in range(len(FORCE_NODALE)):
        __current = FORCE_NODALE[__i]
        __GROUP_F[__current['GROUP_NO']] = np.array([__current['FX'], __current['FY']])

    __GROUP_C = {}
    __j = 1


    __GROUP_C[0] = GROUP_MA_EXT

    if GROUP_MA_INT:
        if type(GROUP_MA_INT) == list:
            __j = 0
            for __current in GROUP_MA_INT:
                __GROUP_C[__j + 1] = __current
                __j = __j + 1
        else:

            for __j in range(len(GROUP_MA_INT)):
                __GROUP_C[__j + 1] = GROUP_MA_INT[__j]
                __j = __j + 1

    __SCHEMA = SCHEMA
    __PAS_ITERPOL_X = PAS_X
    __PAS_ITERPOL_Y = PAS_Y
    __TOLE_BASE = TOLE_BASE
    __TOLE_BT = TOLE_BT
    __MAXITER = NMAX_ITER
    __CONVER1 = RESI_RELA_TOPO
    __CONVER2 = RESI_RELA_SECTION
    __SEVOL = CRIT_SECTION
    __MELIM = CRIT_ELIM
    __MINSEC = SECTION_MINI
    __MAXLON = LONGUEUR_MAX
    __FC = SIGMA_C
    __FY = SIGMA_Y

    iret, ibid, n_mail = aster.dismoi('NOM_MAILLA', RESULTAT.nom, 'RESULTAT', 'F')
    __MAIL = self.get_concept(n_mail)

    __resu = CALC_CHAMP(
                      CONTRAINTE=('SIGM_ELNO', ),
                      CRITERES=('SIEQ_NOEU', ),
                      RESULTAT=RESULTAT)

    __SIEQ = CREA_CHAMP(
                      NOM_CHAM='SIEQ_NOEU',
                      OPERATION='EXTR',
                      INST=INST,
                      RESULTAT=__resu,
                      TYPE_CHAM='NOEU_SIEF_R'
                      )


    #=======================================================================
    # Functions
    #=======================================================================

    def angle_clockwise(A, B):
        """
        Description:
            Basic inclination computation. Angles measured clockwise
        Input :
            A .- matrix containing initial coordinates x and y
            B .- matrix containing final coordinates x and y
        Output :
            co_ca_at[:, 2] .- Angle in degrees [0:360|
        """
        co_ca_at = np.zeros((len(B[:, 0]), 3))
        co_ca_at[:, 0] = B[:, 1] - A[1]    # Oposite cathetus
        co_ca_at[:, 1] = B[:, 0] - A[0]    # Adjacent cathetus

        co_ca_at[:, 2] = np.arctan(np.divide(co_ca_at[:, 0], co_ca_at[:, 1]))

        # Conditions according the current quadrant
        co_ca_at[np.multiply(co_ca_at[:, 0] == 0, co_ca_at[:, 1] > 0), 2] = 0
        # Groupe de noeuds

        co_ca_at[np.multiply(co_ca_at[:, 0] > 0, co_ca_at[:, 1] == 0), 2] = pi/2
        co_ca_at[np.multiply(co_ca_at[:, 0] > 0, co_ca_at[:, 1] < 0), 2] = (pi +
                co_ca_at[np.multiply(co_ca_at[:, 0] > 0, co_ca_at[:, 1] < 0), 2])

        co_ca_at[np.multiply(co_ca_at[:, 0] == 0, co_ca_at[:, 1] < 0), 2] = pi
        co_ca_at[np.multiply(co_ca_at[:, 0] < 0, co_ca_at[:, 1] < 0), 2] = (pi +
                co_ca_at[np.multiply(co_ca_at[:, 0] < 0, co_ca_at[:, 1] < 0), 2])

        co_ca_at[np.multiply(co_ca_at[:, 0] < 0, co_ca_at[:, 1] == 0), 2] = 3*pi/2
        co_ca_at[np.multiply(co_ca_at[:, 0] < 0, co_ca_at[:, 1] > 0), 2] = (2*pi +
                co_ca_at[np.multiply(co_ca_at[:, 0] < 0, co_ca_at[:, 1] > 0), 2])

        return co_ca_at[:, 2]


    #==============================================================================
    def angle_mean(Mesh_, U, V, vertices, regions):
        """
        Description:
            Computes the angular mean of a group of angles contained in a cell.
        Input:
            Mesh_ .- FE nodla list
            U .- Cathetus meassured along x axis
            V .- Cathetus meassured along y axis
            vertices - nodal list of the cells containing the data
            regions .- Connectivity matrix of the cells
        Output:
            mean_CQ .- average slope computed for each cell
        """
        angle_ = np.zeros((len(U), 1))
        for i_ in range(0, (len(U))):    # Computing the associated clockwise angle
            if U[i_] == 0 and V[i_] == 0:
                U[i_] = np.mean(U)
                V[i_] = np.mean(V)

            angle_[i_, 0] = angle_clockwise(np.array([0, 0]),
                  np.array([[U[i_], V[i_]]]))

        AS = np.zeros([len(Mesh_[:, 0]), len(regions)], dtype=bool)
        mean_CQ = np.ones([len(regions), 1])*1000000    # Average angle
        c_VC = np.zeros([len(regions), 2])

        i_ = 0
        for region in regions:
            polygon = vertices[region]

            c_VC[i_,:] = np.mean(polygon, axis = 0)   # Centroid of Voronoi cell
            # print polygon
            for j_ in range(len(vertices)):
                # print vertices
                AS[j_, i_] = np.multiply(is_inpolygon(vertices[j_,:], polygon, 1),
                  (np.isnan(angle_[j_]) == False))

            if sum(AS[:, i_]) != 0:

                reduced_ang = red_ang_disp(angle_[AS[:, i_]])

                if angle_disp_test(reduced_ang):

                    try:
                        mean_CQ[i_, 0] = loess(X, Y, reduced_ang)

                    except:

                        Sin_ = sum(np.sin(reduced_ang))
                        Cos_ = sum(np.cos(reduced_ang))

                        if Sin_ > 0 and Cos_ > 0:
                            mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_)
                        elif Cos_ < 0:
                            mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_) + pi
                        elif Sin_ < 0 and Cos_ > 0:
                            mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_) + 2*pi

                else:

                    Sin_ = sum(np.sin(reduced_ang))
                    Cos_ = sum(np.cos(reduced_ang))

                    if Sin_ > 0 and Cos_ > 0:
                        mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_)
                    elif Cos_ < 0:
                        mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_) + pi
                    elif Sin_ < 0 and Cos_ > 0:
                        mean_CQ[i_, 0] = np.arctan2(Sin_, Cos_) + 2*pi

            i_ = i_ + 1

        return mean_CQ
    #==============================================================================
    def angle_disp_test(angle):
        if (max(angle)-min(angle)) >= 0.0001:
            return False
        else:
            return True

    #==============================================================================
    def ar2tuple(a):
        """
        Description:
            Converts an array into a tupple.
        Input:
            a .- array
        Output:
            a .- tupple
        """
        try:
            return tuple(ar2tuple(i) for i in a)

        except TypeError:

            return a

    #==============================================================================
    def B_BC(__grno, DDL_, FORCE_):
        """
        Description:
            Transfer the continuous boundary conditions to discrete ones.
        Input:
            Mesh_ .- FE nodal list
            GS_ .- Ground structure nodal list
            SUP .- Assigned displacements [Node UX UY UZ]
            LOAD .- Assigned loads [Node FX FY FZ]
        Output:
            N_o_S .- Nodes considered at the supports of the structure
            N_o_L .- Nodes receiving a puntual load
            Mesh_=Nodes_
            GS_=GS_nodes
            SUP=SUPPORTS
            LOAD=LOADS
        """
        __grno = mm.gno

        n = 0
        for key in DDL_.keys():
            n = n + len(np.asarray(__grno[key]))

        SUPPORTS = np.zeros((n, 4), dtype = int) - 1
        for key in DDL_.keys():
            a = sum(SUPPORTS[:, 0] >= 0)
            b = len(np.asarray(__grno[key]))
            SUPPORTS[a:(b + a), 0] = np.asarray(__grno[key])

        n = 0
        for key in FORCE_.keys():
            n = n + len(np.asarray(__grno[key]))


        FORCES = np.zeros((n, 4), dtype = int) - 1
        for key in FORCE_.keys():
            a = sum(FORCES[:, 0] >= 0)
            b = len(np.asarray(__grno[key]))
            FORCES[a:(b + a), 0] = np.asarray(__grno[key])


        return SUPPORTS + 1, FORCES + 1


    #==============================================================================
    def BCA(Mesh_, GS_, SUP, LOAD):
        """
        Description:
            Transfer the continuous boundary conditions to discrete ones.
        Input:
            Mesh_ .- FE nodal list
            GS_ .- Ground structure nodal list
            SUP .- Assigned displacements [Node UX UY UZ]
            LOAD .- Assigned loads [Node FX FY FZ]
        Output:
            N_o_S .- Nodes considered at the supports of the structure
            N_o_L .- Nodes receiving a puntual load
            Mesh_=Nodes_
            GS_=GS_nodes
            SUP=SUPPORTS
            LOAD=LOADS
        """
        N_o_S = np.zeros((len(SUP[:, 0]), 4), dtype= int)

        for i_ in range(len(SUP[:, 0])):
            dist_ = np.sqrt((GS_[:, 0] - Mesh_[int(SUP[i_, 0]) - 1, 1])**2) + \
                np.sqrt((GS_[:, 1] - Mesh_[int(SUP[i_, 0]) - 1, 2])**2)

            N_o_S[i_, 0] = sum(np.multiply(range(len(GS_[:, 0])),
                dist_ == min(dist_))) + 1
            N_o_S[i_, 1:4] = SUP[i_, 1:4]


        N_o_L = np.zeros((len(LOAD[:, 0]), 4), dtype= int)

        for i_ in range(len(LOAD[:, 0])):
            dist_ = np.sqrt((GS_[:, 0] - Mesh_[int(LOAD[i_, 0]) - 1, 1])**2) + \
                np.sqrt((GS_[:, 1] - Mesh_[int(LOAD[i_, 0]), 2] - 1)**2)

            N_o_L[i_, 0] = sum(np.multiply(range(len(GS_[:, 0])),
                dist_ == min(dist_))) + 1
            N_o_L[i_, 1:4] = LOAD[i_, 1:4]

        return N_o_S, N_o_L


    #==============================================================================
    def BCA2(Mesh_, GS_, __BC):
        """
        Description:
            Transfer the continuous boundary conditions to discrete ones.
        Input:
            Mesh_ .- FE nodal list
            GS_ .- Ground structure nodal list
            SUP .- Assigned displacements [Node UX UY UZ]
            LOAD .- Assigned loads [Node FX FY FZ]
        Output:
            N_o_S .- Nodes considered at the supports of the structure
            N_o_L .- Nodes receiving a puntual load
            Mesh_=Nodes_
            GS_=GS_nodes
            SUP=SUPPORTS
            LOAD=LOADS
        """
        __grno = mm.gno

        N_o_S = dict()

        for key in __grno.keys():
            SUP = np.asarray(__grno[key])
            b = np.zeros((len(SUP[:])), dtype= int)
            for i_ in range(len(SUP[:])):
                dist_ = np.sqrt((GS_[:, 0] - Mesh_[int(SUP[i_]), 1])**2) + \
                    np.sqrt((GS_[:, 1] - Mesh_[int(SUP[i_]), 2])**2)

                b[i_] = sum(np.multiply(range(len(GS_[:, 0])), dist_ == min(dist_))) + 1

            N_o_S.update({key:np.unique(b)})


        return N_o_S


    #==============================================================================
    def B_inter_V(V_regions, V_vertices, B_region, B_vertices):
        """
        Description:
            Vornoi division intersected with a general polyhedron. Finds the
            intersections between a finite Voronoï tesselation and group of segments
            describing a geometry
        Input:
            V_regions and V_vertices .- Matrice describing the Voronoï tessellation
            B_region, B_vertices .-  Matrice describing the Geometry to intersect
        Output:
            N_V .- Coordinates of the intersections
        """
        N_V = np.empty((len(B_region)*len(V_regions), 5))
        N_V[:] = np.nan
        i_ = 0

        for v_1 in range (0, len(V_regions)):    # Intersections Voronoi-boundary
            v_cell = np.zeros([1, len(V_regions[v_1]) + 1], dtype=int)
            v_cell[0, 0:-1] = V_regions[v_1]
            v_cell[0, -1] = v_cell[0, 0]

            for NB in range (0, (len(B_region) - 1)):    # Variating boundary lines

                # Intersection lines
                for NS in range (len(V_regions[v_1])):
                    p = get_intersect(B_vertices[B_region[NB],:],
                            B_vertices[B_region[NB + 1],:],
                            V_vertices[v_cell[0, NS],:],
                            V_vertices[v_cell[0, NS + 1],:])

                    a = isinline(np.array([
                            [B_vertices[B_region[NB], 0],
                            B_vertices[B_region[NB], 1]],
                            [B_vertices[B_region[NB + 1], 0],
                            B_vertices[B_region[NB + 1], 1]]]),
                            p)    # First segment intersection

                    b = isinline(np.array([
                            [V_vertices[v_cell[0, NS], 0],
                            V_vertices[v_cell[0, NS], 1]],
                            [V_vertices[v_cell[0, NS + 1], 0],
                            V_vertices[v_cell[0, NS + 1], 1]]]),
                            p)    # Second segment intersection

                    if (a*b) == 1:    # Intersection contained within the segments
                        N_V[i_, [0, 1]] = p
                        N_V[i_, [2]] = v_1    # Contained cell
                        N_V[i_, [3]] = NS    # Voronoi line
                        N_V[i_, [4]] = NB    # Boundary line
                        i_ = i_ + 1

        return N_V[(np.isnan(N_V[:, 0]) != 1),:]

    #==============================================================================
    def Cr_loop(_vector):
        """

        """
        if _vector[0] == _vector[-1]:
            return _vector

        else:
            _vector1 = np.zeros((len(_vector) + 1))
            _vector1[range(len(_vector))] = _vector
            _vector1[-1] = _vector[0]
            return _vector1


    def charposition(string, char):
        pos = [] #list to store positions for each 'char' in 'string'
        for n in range(len(string)):
            if string[n] == char:
                pos.append(n)
        return pos
    #==============================================================================
    def clipped_2D(N_Bound, Bound, vertices, regions, N_V):
        """
        Description:
            Clipping a Voronoi division. the results must be concave cells
        Input:
            N_Bound .- Nodes of the geometry to contain the Voronoï division
            Bound .- Connectivity matrix of the geometry
        Output:
            vertices .- vertices contained whitin the limits of the geometry
            regions .- connectivity matrix of the clipped cells
        """
        Polygon = N_Bound[Bound,:]
        inside = [is_inpolygon(vertice, Polygon) for vertice in vertices]
        outside = list(np.asarray(inside) == False)

        SSS = np.asarray(Polygon)



        vertices_ = np.empty((len(vertices[:, 0]) + 2*len(N_V[:, 0]), 2, ))
        vertices_[:] = np.nan
        vertices_[0:len(vertices),:] = vertices

        i_ = 0
        for region in regions:
            n_v = sum(N_V[:, 2] == i_)    # New possible vertices in the region

            if n_v >= 1:
                n = sum(list(np.isnan(vertices_[:, 0]) == False))
                Polygon_ = vertices[region,:]
                inside_v = [is_inpolygon(vertice_B,     # Boundary vertices inside
                    Polygon_) for vertice_B in N_Bound]  # the cell

                if sum(inside_v) > 0:
                    uno = np.array(range(0, len(vertices[:, 0])))
                    dos = uno[inside]
                    uno = uno[outside]
                    to_del = list(set(uno) & set(region))    # Nodes to delete
                    to_keep = list(set(dos) & set(region))
                    to_add = N_V[N_V[:, 2] == i_, 0:2]    # Nodes to add

                    b = len(to_del)
                    c = 0
                    for del_ in to_del:
                        a = np.where(np.array(region) == del_)
                        a = a[0].astype(np.int32)
                        b = (min(a, b))
                        c = (max(a, c))

                    C_r = [0] * (len(region) + len(to_add) - len(to_del) + \
                        sum(inside_v))

                    C_r[0:len(to_keep)] = to_keep
                    C_r[(len(to_keep)):(len(to_keep) + len(to_add))] =\
                            range(n, n + len(to_add))
                    C_r[(len(to_add) + len(to_keep)):] = range((n + len(to_add)),
                        (n + len(to_add) + sum(inside_v)))

                    vertices_[n:(n + len(to_add[:, 0])),:] = to_add
                    vertices_[(n + len(to_add[:, 0])):(n + 2 + sum(inside_v)),:] =  \
                        N_Bound[inside_v,:]
                    a_ = ordering(vertices_, C_r)
                    C_r = [ C_r[i] for i in a_]
                    regions[i_] = C_r

                elif sum(inside_v) == 0:
                    uno = np.array(range(0, len(vertices[:, 0])))
                    dos = uno[inside]
                    uno = uno[outside]
                    to_del = list(set(uno) & set(region))    # Nodes to delete
                    to_keep = list(set(dos) & set(region))
                    to_add = N_V[N_V[:, 2] == i_, 0:2]    # Nodes to add

                    b = len(to_del)
                    c = 0
                    for del_ in to_del:
                        a = np.where(np.array(region) == del_)
                        a = a[0].astype(np.int32)
                        b = (min(a, b))
                        c = (max(a, c))

                    C_r = [0] * (len(region) + len(to_add) - len(to_del))
                    C_r[0:len(to_keep)] = to_keep
                    C_r[len(to_keep):] = range(n, (n + len(C_r) - len(to_keep)))

                    # region[b[0]]
                    vertices_[n:(n + len(to_add[:, 0])),:] = to_add
                    a_ = ordering(vertices_, C_r)
                    C_r = [ C_r[i] for i in a_]
                    regions[i_] = C_r

                    regions[i_] = C_r
            i_ = i_ + 1
        vertices = vertices_[(np.isnan(vertices_[:, 0]) != 1),:]

        return regions, vertices

    #==============================================================================
    def count_digit(num_, *Opt1):
        """
        Description:
            Counts the digits of a number
        Input:
            num_ .- number
            *Opt1 .- take into account the sign [0 1]
        Output:
            digits .- number of digits
        """
        digits = 0

        if num_ > 0:
            digits = int(log(num_, 10)) + 1
        elif num_ == 0:
            digits = 1
        else:
            digits = int(log(-num_, 10)) + 2 # +1 if you don't count the '-'

        return digits



    #==============================================================================
    def count_dup(a):
        """

        """
        A = np.unique(a)
        B = np.zeros((len(A)), dtype = int)    # Number of repetitions

        for i_ in range(len(A)):
            B[i_] = int(np.sum(a == A[i_]))

        return A, B

    #==============================================================================
    def double_nodes(N_Bound, Bound, points, diameter_, Opt1):
        """
        Description:
            Computes intersections between segments of lines and circles whose
            center lays in the coordinates given in the matrix points.
        Input .-
            N_Bound .- Nodal list of the boundaries
            Bound .- Boundary connectivity matrix
            points .- Coordinates of points to be evaluated
            diameter_ .- Diameter of the cercle to create the intersections
            Opt1 .- Take into account internal peaks [0, 1]
        Output .-
            New_ .- Intersections
        """
        New_ = np.zeros((len(points[:, 0])*4, 2))    # Pre-locating matrices
        New_[:] = np.nan

        N_Vert = 4    # Circle discretization

        # i_ = 0
        for centre_ in points:
            S_C = np.zeros((N_Vert + 1, 2))
            S_C[:, 1] = diameter_*np.sin(np.linspace(0, 2*pi, N_Vert + 1)) + \
                centre_[1]
            S_C[:, 0] = diameter_*np.cos(np.linspace(0, 2*pi, N_Vert + 1)) + \
                centre_[0]

            a = intersections_(S_C, range(N_Vert), N_Bound, Bound, 1)

            a = unique_local(np.round(a, 5))

            s_ = sum(np.isnan(New_[:, 0]) == False)

            if sum(sum(np.isnan(a))) and Opt1 == 1:
                New_[s_:(s_ + N_Vert),:] = S_C[0:-1,:]

            elif sum(sum(np.isnan(a))) and Opt1 != 1:
                pass
            else:
                New_[s_:(s_ + len(a[:, 0])),:] = a

        return New_[np.isnan(New_[:, 0]) == False,:]

    #==============================================================================
    def erase_el(GS_nodes, Con_Mat, N_Bound, Holes):
        """
        Description:
            Erase the elements contained or just crossing the holdes of the geometry.
        Input:
            GS_nodes .- Element's nodes
            Con_Mat .- Element's connectivity matrix
            N_Bound .- Nodal list of the holes
            Holes .- Holes connectivity matrix
        Output:
            A = Nodes inside the holes
        """
        A = np.ones((len(Con_Mat[:, 0])), dtype=bool)

        discr = 10
        for key in Holes.keys():
            B = Holes[key]
            poly = N_Bound[B.astype(int), 1:3]


            for i_ in range(len(Con_Mat)):
                inter_p = np.zeros((discr, 2))
                inter_p[:, 0] = np.linspace(GS_nodes[Con_Mat[i_, 0], 0],
                                GS_nodes[Con_Mat[i_, 1], 0], discr)
                inter_p[:, 1] = np.linspace(GS_nodes[Con_Mat[i_, 0], 1],
                                GS_nodes[Con_Mat[i_, 1], 1], discr)

                for pp in inter_p:
                    if is_inpolygon(pp, poly):
                        A[i_] = False
                        break

        return A


    #==============================================================================
    def Erase_nodes(GS_nodes, Con_Mat, N_o_S, N_S, N_L, GROUP_S, GROUP_F):
        """
        Description:
            Erase un associated nodes and modifies the connectivity matrix
        Input:
            GS_nodes .- Nodal list
            Con_Mat .- Connectivity matrix
        Output:
            GS_nodes .- New nodal list
            N_Con_Mat .- New connectivity matrix
        """
        A = np.unique(Con_Mat)    # Used nodes in the model

        B_ = np.zeros((len(GS_nodes[:, 0]), 2))    # Renumbering vector
        B_[:] = np.nan
        B_[A.astype(int), 0] = A
        B_[np.isnan(B_[:, 0]) == False, 1] = np.arange(0, len(A), 1)

        N_Con_Mat = np.zeros((len(Con_Mat[:, 0]), 2), dtype = int)
        N_Con_Mat[:, 0] = B_[Con_Mat[:, 0], 1]
        N_Con_Mat[:, 1] = B_[Con_Mat[:, 1], 1]




        Steady = np.zeros((len(N_S[:, 0]) + len(N_L[:, 0])), dtype = int)

        i_ = 0

        for key in range(len(N_S[:, 0])):
            Steady[i_] = N_S[key, 0]
            i_ = i_ + 1


        number = 0
        for key in N_o_S.keys():
            QDoF = np.zeros((len(N_o_S[key])), dtype = int)
            QDoF[:] = B_[N_o_S[key] - 1, 1] + 1
            N_o_S[key] = QDoF
            number = number + len(N_o_S[key])


        j_ = 0
        N_S = np.zeros((len(N_S[:, 0]), 3))
        for key in GROUP_S.keys():
            AB = GROUP_S[key]
            if len(AB) <= 1:
                N_S[j_, 1::] = AB.astype(float)
                N_S[np.isnan(N_S)] = 10e9
                N_S[j_, 0] = int(N_o_S[key])
                j_ = j_ + 1
            else:
                BC = N_o_S[key]
                for i_ in range(len(BC)):
                    N_S[j_, 1::] = AB.astype(float)
                    N_S[np.isnan(N_S)] = 10e9
                    N_S[j_, 0] = int(BC[i_])
                    j_ = j_ + 1






        j_ = 0

        for key in GROUP_F.keys():
            N_L[j_, 1::] = GROUP_F[key]

            N_L[j_, 0] = int(N_o_S[key])
            j_ = j_ + 1

        return GS_nodes[np.isnan(B_[:, 0]) == False,:], N_Con_Mat, N_o_S, N_S, N_L


    #==============================================================================
    def find_nearest(array, value):
        """

        """
        array = np.asarray(array)
        idx = (np.abs(array - value)).argmin()
        return array[idx]

    #==============================================================================
    def Grid_sq(div_):
        """

        """
        Grid_ = np.zeros(((div_ + 1)**2, 2))
        x = np.linspace(0, 1, div_ + 1)
        xv, yv = np.meshgrid(x, x)
        Grid_[:, 0] = np.asarray(xv).reshape(-1)
        Grid_[:, 1] = np.asarray(yv).reshape(-1)

        return Grid_


    #==============================================================================
    def general_geom(NL, EL):
        """
        Description :
            Plot a general 2D truss.
        Input :
            NL = Nodes_[:, 1:3]
            EL = Elements_[:, 6:10]
        Output :
            figure
        """
        GE_plot = np.zeros((len(EL[:, 0])*6, 2))
        GE_plot[:] = np.nan
        GE_plot[range(0, len(EL[:, 0])*6, 6),:] = NL[EL[:, 0] - 1,:]
        GE_plot[range(1, len(EL[:, 0])*6, 6),:] = NL[EL[:, 1] - 1,:]

        GE_plot[range(2, len(EL[:, 0])*6, 6),:] = NL[EL[:, 2] - 1,:]
        GE_plot[range(3, len(EL[:, 0])*6, 6),:] = NL[EL[:, 3] - 1,:]

        GE_plot[range(4, len(EL[:, 0])*6, 6),:] = NL[EL[:, 0] - 1,:]



    #==============================================================================
    def get_intersect(a1, a2, b1, b2):
        """
        Description:
        Returns the point of intersection between the lines passing through a2,a1
        and b2,b1.
        Input:
            a1 .- a point on the first line
            a2 .- another point on the first line
            b1 .- a point on the second line
            b2 .- another point on the second line
        Output:
            intersection (x, y)
        """
        s = np.vstack([a1, a2, b1, b2])        # s for stacked
        h = np.hstack((s, np.ones((4, 1)))) # h for homogeneous
        l1 = np.cross(h[0], h[1])           # get first line
        l2 = np.cross(h[2], h[3])           # get second line
        x, y, z = np.cross(l1, l2)          # point of intersection

        if z == 0:                          # lines are parallel
            return (float('inf'), float('inf'))
        return (x/z, y/z)


    #==============================================================================
    def grid_interp(Coord_, Data_, x_d, y_d, __Holes, __Nodes):
        """
        Description:
        Creates a grid interpolation of a given data.
        Input:
        Coord_ .- Data coordinates
        Data .- Values to interpolate
        x_d .- x espacing
        y_d .- y espacing
        Output:
        grid_x .- X coordinates of the interpolation points
        grid_y .- Y coordinates of the interpolation points
        grid_z1 .- interpolated data
        """
        from Utilitai.griddata_local import griddata

        grid_x, grid_y = np.mgrid[min(Coord_[:, 0]): max(Coord_[:, 0]): x_d, \
                                  min(Coord_[:, 1]): max(Coord_[:, 1]): y_d]

        A = np.ones((len(grid_x[:, 0]), len(grid_x[0,:])), dtype=bool)
        if len(__Holes) > 0:
            for key in __Holes.keys():
                for i_ in range(len(grid_x[:, 0])):
                    for j_ in range(len(grid_x[0,:])):
                        if is_inpolygon([grid_x[i_, j_], grid_y[i_, j_]], __Nodes[__Holes[key], 1:3], 0):
                            A[i_, j_] = False

        grid_z1 = griddata(Coord_, Data_, grid_x, grid_y, A)
        return grid_x, grid_y, grid_z1


    #==============================================================================
    def Invert_test(K, IDoF):
        """
        Description:
        Tests the inversibility of a matrix.
        Input:
        K .- Stiffness matrix
        IDoF .- Impossedd degrees of freedom
        Output:
        True or False
        """
        A = np.arange(len(IDoF))
        A = A[IDoF]


        K_red = np.zeros((len(A), len(A)))

        for i_ in range(len(A)):
            K_red[i_,:] = K[A[i_], IDoF]




        A = K_red[range(len(K_red)), range(len(K_red))]
        ratio_ = min(abs(A))/max(abs(A))
        C = np.diag(K_red)

        if 0 in C:

            B = False

        elif (min(abs(A)) < 10**-6):
            B = False

        else:
            B = True

        return B


    #==============================================================================
    def isinline(line, P1):
        """
        Description:
        Verifies if a point lays in a segment.
        Input:
        line .- initial and final coordinates
        P1 .- Point to evaluated
        Output:
        0 or 1
        """
        abc = np.zeros([3, 3])
        abc[0:2, 0:2] = line[:, [0, 1]]
        abc[2, [0, 1]] = P1
        abc[:, 2] = np.sqrt((abc[:, 0] -      #Eucledian distances
            abc[[1, 2, 0], 0])**2 +
            (abc[:, 1] - abc[[1, 2, 0], 1])**2)
        if abs(abc[0, 2] - abc[1, 2] - abc[2, 2]) < abc[0, 2]/10000:
            return 1
        else:
            return 0


    #==============================================================================
    def intersections_(vertices_1, Bound_1, vertices_2, Bound_2, Opt1):
        """

        """
        Bound_1 = np.array(Bound_1, dtype=int)
        Bound_2 = np.array(Bound_2, dtype=int)
        if Opt1 == 1:    # Close the boundaries
            if Bound_1[0] != Bound_1[-1]:
                A = np.zeros(((len(Bound_1[:]) + 1)), dtype=int)
                A[0:-1] = Bound_1
                A[-1] = Bound_1[0]
                Bound_1 = A

            if Bound_2[0] != Bound_2[-1]:
                A = np.zeros(((len(Bound_2[:]) + 1)), dtype=int)
                A[0:-1] = Bound_2
                A[-1] = Bound_2[0]
                Bound_2 = A

        intersec_ = np.zeros(((len(Bound_1) - 1)*(len(Bound_2) - 1), 2))
        intersec_[:] = np.nan

        for i_ in range(len(Bound_1) - 1):
            for j_ in range(len(Bound_2) - 1):
                cross_point = get_intersect(vertices_1[Bound_1[i_],:],
                              vertices_1[Bound_1[i_ + 1],:],
                              vertices_2[Bound_2[j_],:],
                              vertices_2[Bound_2[j_ + 1],:])
                des_1 = isinline(vertices_2[Bound_2[j_:(j_ + 2)],:], cross_point)
                des_2 = isinline(vertices_1[Bound_1[i_:(i_ + 2)],:], cross_point)
                if des_1*des_2 == 1:
                    s_ = sum(np.isnan(intersec_[:, 0]) == False)
                    intersec_[s_,:] = cross_point

        if sum(np.isnan(intersec_[:, 0]) == False) > 0:
            p = unique_local(intersec_[np.isnan(intersec_[:, 0]) == False,:])
            # p = np.unique(intersec_[np.isnan(intersec_[:, 0]) == False, :], axis=0)

        else:

            p = np.array([[np.nan]])

        return p


    #==============================================================================
    def is_inpolygon(xy, poly, *Opt1):
        """
        xy .-
        poly .-
        Opt1 .-
        """
        n = len(poly[:, 1])
        inside = False
        x = xy[0]
        y = xy[1]
        p1x, p1y = poly[0]
        for i in range(n+1):
            p2x, p2y = poly[i % n]
            if y > min(p1y, p2y):
                if y <= max(p1y, p2y):
                    if x <= max(p1x, p2x):
                        if p1y != p2y:
                            xints = (y-p1y)*(p2x-p1x)/(p2y-p1y)+p1x
                        if p1x == p2x or x <= xints:
                            inside = not inside
            p1x, p1y = p2x, p2y

        Opt1 = sum(Opt1)
        if Opt1 == 1:

            if poly[0, 0] != poly[-1, 0]:
                A = np.zeros(((len(poly[:]) + 1), 2))
                A[0:-1,:] = poly
                A[-1,:] = poly[0,:]
                poly = A

            for i_ in range(len(poly[:, 0]) - 1):
                line = poly[i_:(i_ + 2),:]
                a = isinline(line, xy)
                if a == 1:
                    break
            if a == 1:
                inside = True

        return inside


    #==============================================================================
    def K_matrix(GS_nodes, Con_Mat, E_sections, Mat_prp, Forces):
        """
        Description:
            Assembles the stiffness matrix of the structure.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
            Mat_prp .- Material proprerties
            Forces .- Forces on the elements
        Output:
            K .- Global stiffness matrix

        """
        K = np.zeros((len(GS_nodes[:, 0])*2, len(GS_nodes[:, 0])*2))    # Global K

        Elem_L = Length_(GS_nodes, Con_Mat)    # Element length
        Young_m = np.zeros((len(E_sections)))    # Associated young modulus
        Young_m[Forces > 0] = Mat_prp[0, 1]
        Young_m[Forces <= 0] = Mat_prp[1, 1]
        A = np.array([0, 0])
        B = np.array([[0, 0]])

        co_ca_at = np.zeros((len(Con_Mat[:, 0]), 3))
        co_ca_at[:, 0] = GS_nodes[Con_Mat[:, 1], 1] - GS_nodes[Con_Mat[:, 0], 1]
        co_ca_at[:, 1] = GS_nodes[Con_Mat[:, 1], 0] - GS_nodes[Con_Mat[:, 0], 0]
        co_ca_at[:, 2] = np.arctan2(co_ca_at[:, 0], co_ca_at[:, 1])

        for i_ in range(len(Con_Mat[:, 0])):
            k = (Young_m[i_]*E_sections[i_]/Elem_L[i_]) *\
                            np.array([[1, 0, -1, 0],
                                      [0, 0, 0, 0],
                                      [-1, 0, 1, 0],
                                      [0, 0, 0, 0]])#Local element SM

            A[:] = GS_nodes[Con_Mat[i_, 0],:]
            B[:] = GS_nodes[Con_Mat[i_, 1],:]
            C = np.cos(co_ca_at[i_, 2])
            S = np.sin((co_ca_at[i_, 2]))

            R = np.array([[C, -S, 0, 0],
                          [S, C, 0, 0],
                          [0, 0, C, -S],
                          [0, 0, S, C]])

            k_ = np.Mat_prpmul(np.ndarray.transpose(R), np.Mat_prpmul(k, R))    #global ESM
            ADoF = np.zeros((4), dtype = int)
            ADoF[0:2] = [(Con_Mat[i_, 0]*2), Con_Mat[i_, 0]*2 + 1]
            ADoF[2:4] = [(Con_Mat[i_, 1]*2), Con_Mat[i_, 1]*2 + 1]

            for j_ in range(4):
                for m_ in range(4):
                    K[ADoF[j_], ADoF[m_]] = k_[j_, m_]

        return K


    #==============================================================================
    def K_matrix1by1(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY, Forces, IDoF, Elem_prin, method):
        """
        Description:
            Assembles the stiffness matrix of the structure and evaluates the       inversibility.
        Input:
        GS_nodes .- Element nodal list
        Con_Mat .- Element conectivity matrix
        E_sections .- Asigned element sections
        Mat_prp .- Material proprerties
        Forces .- Forces on the elements
        IDoF .- Impossed degrees of freedom
        percent .- percent of elements to test
        Output:
        Con_Mat .- Element conectivity matrix (updated)
        E_sections .- Asigned element sections (updated)
        Forces .- Forces on the elements (updated)
        """
        K = np.zeros((len(GS_nodes[:, 0])*2, len(GS_nodes[:, 0])*2))    # Global K

        Elem_L = Length_(GS_nodes, Con_Mat)    # Element length
        Young_m = np.zeros((len(E_sections)))    # Associated Young modulus
        Young_m[Forces > 0] = Es
        Young_m[Forces <= 0] = Ec
        A = np.array([0, 0])
        B = np.array([[0, 0]])


        co_ca_at = np.zeros((len(Con_Mat[:, 0]), 3))
        co_ca_at[:, 0] = GS_nodes[Con_Mat[:, 1], 1] - GS_nodes[Con_Mat[:, 0], 1]
        co_ca_at[:, 1] = GS_nodes[Con_Mat[:, 1], 0] - GS_nodes[Con_Mat[:, 0], 0]
        co_ca_at[:, 2] = np.arctan2(co_ca_at[:, 0], co_ca_at[:, 1])

        for i_ in range(Elem_prin):
            k = (Young_m[i_]*E_sections[i_]/Elem_L[i_]) *\
                            np.array([[1, 0, -1, 0],
                                      [0, 0, 0, 0],
                                      [-1, 0, 1, 0],
                                      [0, 0, 0, 0]])#Local element SM

            A[:] = GS_nodes[Con_Mat[i_, 0],:]
            B[:] = GS_nodes[Con_Mat[i_, 1],:]
            C = np.cos(co_ca_at[i_, 2])
            S = np.sin((co_ca_at[i_, 2]))

            R = np.array([[C, -S, 0, 0],
                          [S, C, 0, 0],
                          [0, 0, C, -S],
                          [0, 0, S, C]])

            k_ = matmult(np.ndarray.transpose(R), matmult(k, R))    # global ESM
            ADoF = np.zeros((4), dtype = int)
            ADoF[0:2] = [(Con_Mat[i_, 0]*2), Con_Mat[i_, 0]*2 + 1]
            ADoF[2:4] = [(Con_Mat[i_, 1]*2), Con_Mat[i_, 1]*2 + 1]



            for j_ in range(4):
                for m_ in range(4):
                    K[ADoF[j_], ADoF[m_]] = k_[j_, m_]

        for i_ in range(Elem_prin, len(Con_Mat[:, 0])):
            if Invert_test(K, IDoF):
                Con_Mat = Con_Mat[np.arange(i_ - 1),:]    # Erasing secondary elements
                E_sections = E_sections[np.arange(i_ - 1)]
                Forces = Forces[np.arange(i_ - 1)]
                break

            else:
                k = (Young_m[i_]*E_sections[i_]/Elem_L[i_]) *\
                                np.array([[1, 0, -1, 0],
                                          [0, 0, 0, 0],
                                          [-1, 0, 1, 0],
                                          [0, 0, 0, 0]])#Local element SM

                A[:] = GS_nodes[Con_Mat[i_, 0],:]
                B[:] = GS_nodes[Con_Mat[i_, 1],:]
                C = np.cos(co_ca_at[i_, 2])
                S = np.sin((co_ca_at[i_, 2]))

                R = np.array([[C, -S, 0, 0],
                              [S, C, 0, 0],
                              [0, 0, C, -S],
                              [0, 0, S, C]])

                k_ = matmult(np.ndarray.transpose(R), matmult(k, R))    #global ESM
                ADoF = np.zeros((4), dtype = int)
                ADoF[0:2] = [(Con_Mat[i_, 0]*2), Con_Mat[i_, 0]*2 + 1]
                ADoF[2:4] = [(Con_Mat[i_, 1]*2), Con_Mat[i_, 1]*2 + 1]

                for j_ in range(4):
                    for m_ in range(4):
                        K[ADoF[j_], ADoF[m_]] = k_[j_, m_]


        if Invert_test(K, IDoF) == False:
            UTMESS('F', 'CALCBT_6')

        return Con_Mat, E_sections, Forces


    #==============================================================================
    def Length_(N_path, Con_Mat):
        """
        """
        a = np.sqrt((N_path[Con_Mat[:, 1], 0] - N_path[Con_Mat[:, 0], 0])**2 + \
            (N_path[Con_Mat[:, 1], 1] - N_path[Con_Mat[:, 0], 1])**2)

        return a


    #==============================================================================
    def local_max(grid_x, grid_y, grid_z1):
        """
        Description:
            Computes discrete derivatives in order to find local maximal and minimal
            based on the changes of sing in the derivatives.
        Input:
            grid_x .- values of X
            grid_y .- values of Y
            grid_z1 .- values of Z
        Output:
            P_coord .- Coordinates of the peaks found
            V_coord .- Coordinates of the valleys found

        """
        # Prelocating Mat_prprices
        P_1 = np.ones((len(grid_z1[:, 0]), len(grid_z1[0,:])), dtype = int)
        P_2 = np.ones((len(grid_z1[:, 0]), len(grid_z1[0,:])), dtype = int)
        V_1 = np.ones((len(grid_z1[:, 0]), len(grid_z1[0,:])), dtype = int)
        V_2 = np.ones((len(grid_z1[:, 0]), len(grid_z1[0,:])), dtype = int)

        for j_ in range(len(grid_y[:, 0])):
            y = grid_z1[j_,:]
            x = grid_x[0,:]
            Mx_mn = Peaks_n_Valleys(x, y)
            P_1[j_,:] = np.multiply(Mx_mn < 0, P_1[j_,:])
            V_1[j_,:] = np.multiply(Mx_mn > 0, V_1[j_,:])


        for j_ in range(len(grid_y[0,:])):
            y = grid_z1[:, j_]
            x = grid_y[:, 0]
            Mx_mn = Peaks_n_Valleys(x, y)
            P_2[:, j_] = np.multiply(Mx_mn < 0, P_2[:, j_])
            V_2[:, j_] = np.multiply(Mx_mn > 0, V_2[:, j_])

        Peaks_ = np.multiply(P_1, P_2)
        P_coord = np.zeros((sum(sum(Peaks_)), 2))
        P_coord[:, 0] = np.reshape(grid_x[Peaks_ == 1], -1, 1)
        P_coord[:, 1] = np.reshape(grid_y[Peaks_ == 1], -1, 1)

        Valleys = np.multiply(V_1, V_2)
        V_coord = np.zeros((sum(sum(Valleys)), 2))
        V_coord[:, 0] = np.reshape(grid_x[Valleys == 1], -1, 1)
        V_coord[:, 1] = np.reshape(grid_y[Valleys == 1], -1, 1)





        return P_coord, V_coord


    #==============================================================================
    def matmult(A, B):

        rows_A = len(A)
        cols_A = len(A[0])
        rows_B = len(A)
        cols_B = len(B[0])

        C = np.zeros((cols_B, rows_A))

        for i in range(rows_A):
            for j in range(cols_B):
                for k in range(cols_A):
                    C[i, j] += A[i][k] * B[k][j]
        return C

    #==============================================================================
    def merge_nodes(GS_nodes_, tolerance, weigth):
        """

        """
        if len(weigth) < 1:
            weigth = np.zeros((len(GS_nodes_[:, 0])))

        for i_ in range(len(GS_nodes_[:, 0])):
            dist_ = np.sqrt((GS_nodes_[i_, 0] - GS_nodes_[:, 0])**2 +
                (GS_nodes_[i_, 1] - GS_nodes_[:, 1])**2)

            # to_merge =np.zeros((len(GS_nodes_[:, 0])), dtype=bool)
            to_merge = (dist_ <= tolerance)

            if np.sum(np.multiply(weigth == 1, to_merge)) == 1:
                mean_point = np.zeros((2))
                mean_point[:] = GS_nodes_[np.multiply(weigth == 1, to_merge), 0:2]

            elif np.sum(np.multiply(weigth == 1, to_merge))  == 0:
                mean_point = np.mean(GS_nodes_[to_merge, 0:2], axis=0)

            elif np.sum(np.multiply(weigth == 1, to_merge))  > 1:
                mean_point = np.mean(GS_nodes_[np.multiply(weigth == 1, to_merge),
                                              0:2], axis=0)

            GS_nodes_[to_merge, 0] = round(mean_point[0], 2)
            GS_nodes_[to_merge, 1] = round(mean_point[1], 2)


        return unique_local(GS_nodes_)


    #==============================================================================

    def mesh_create2(GS_nodes, Con_Mat, N_o_S, Forces, Title_, dir_path, __GROUP_S, __GROUP_F):
        """
        Description:
            Creates the geometry in mail forMat_prp
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Connectivity matrix
            N_o_L .- Nodes associated to the loads
            N_o_S .- Nodes associated to the supports
            Forces .- Forces obtained on the previous computation
            Title_ .- File title
            dir_path .- Work directory
        Output:
            gmail file
        """
        resu = []
        resu.append('TITRE')
        resu.append('FINSF')
        resu.append('COOR_%dD' % 3)


        for i_ in range(len(GS_nodes[:, 0])):   #Nodal list

            add_s1 = ' '*(8 - count_digit(i_ + 1))
            add_s2 = ' '*int(np.sign(GS_nodes[i_, 0]) >= 0)
            add_s3 = ' '*int(np.sign(GS_nodes[i_, 1]) >= 0)

            if GS_nodes[i_, 0] == 0:
                add_s2 = ' '
                GS_nodes[i_, 0] = 0
            if GS_nodes[i_, 1] == 0:
                add_s3 = ' '
                GS_nodes[i_, 1] = 0

            resu.append(' N%d' % (i_ + 1) + add_s1 + add_s2 + '%.14E' % (GS_nodes[i_, 0]) + add_s3 + ' %.14E' % (GS_nodes[i_, 1]) + '  %.14E' % (0))

        resu.append('FINSF')

        resu.append('SEG2')
        for i_ in range(len(Con_Mat[:, 0])):    #Connectivity matrix

            add_s1 = ' '*(8 - count_digit(i_ + 1))
            add_s2 = ' '*(8 - count_digit(Con_Mat[i_, 0] + 1))

            resu.append(' M%d' % (i_ + 1) + add_s1 + 'N%d' % (Con_Mat[i_, 0] + 1) + add_s2 + 'N%d' % (Con_Mat[i_, 1] + 1))

        resu.append('FINSF')

        # Groups of nodes
        for i_ in range(len(GS_nodes[:, 0])):    # All nodes
            resu.append('GROUP_NO')
            resu.append('Node_%d' % (i_ + 1))
            resu.append('N%d' % (i_ + 1))
            resu.append('FINSF')


        i = 1

        for key in __GROUP_S.keys():    # Nodes on the boundary conditions

            try:
                S1 = N_o_S[key]

                for i_ in range(len(S1)):
                    resu.append('GROUP_NO')
                    resu.append('SUP_%d' % i)
                    resu.append('N%d ' % (S1[i_]))
                    resu.append('FINSF')
                    i = i + 1

            except:
                resu.append('GROUP_NO')
                resu.append('SUP_%d' % i)
                resu.append('N%d ' % (N_o_S[key]))
                resu.append('FINSF')
                i = i + 1

        i = 1
        for key in __GROUP_F.keys():    # Nodes on the boundary conditions
            resu.append('GROUP_NO')
            resu.append('LOAD_%d' % i)
            resu.append('N%d' % (N_o_S[key]))
            resu.append('FINSF')
            i = i + 1



        for i_ in range(len(Con_Mat[:, 0])):    # Groups of elements
            resu.append('GROUP_MA')
            resu.append('EG_%d' % (i_ + 1))
            resu.append('M%d' % (i_ + 1))
            resu.append('FINSF')

        Tot = np.zeros((len(Forces)), dtype = int)
        Tot[:] = range(1, (len(Forces) + 1))


        if sum(Forces > 0) == len(Forces):    # Only ties in the model
            resu.append('GROUP_MA')
            resu.append('Ties')
            for i_ in Tot[Forces > 0]:

                resu.append('M%d' % (i_) + ' '*(8 - count_digit(i_)))

            resu.append('FINSF')

        elif sum(Forces <= 0) == len(Forces):    # Only struts in the model
            resu.append('GROUP_MA')
            resu.append('Struts')
            for i_ in Tot[Forces <= 0]:
                resu.append('M%d' % (i_) + ' '*(8 - count_digit(i_)))

            resu.append('FINSF')

        else:

            resu.append('GROUP_MA')
            resu.append('Ties')

            for i_ in Tot[Forces > 0]:
                resu.append('M%d' % (i_ ) + ' '*(8 - count_digit(i_)))

            resu.append('FINSF')


            resu.append(' GROUP_MA')
            resu.append(' Struts')
            for i_ in Tot[Forces <= 0]:
                resu.append('M%d' % (i_) + ' '*(8 - count_digit(i_)))
            resu.append('FINSF')

        resu.append('FIN')
        resu.append('')


        return resu


    #==============================================================================
    def strut_path(seeds, mean_CQ, vertices, regions, N_Bound, Bound):
        """
        Description:
            Proposes the first strut path based on the computed directions and
            Voronoï division.
        Input:
            seeds .- Seeds to grow the branches
            mena_CQ .- Computed mean direction per zone
            vertices .- Voronoï cells' vertices
            regions .- Cells' connectivity matrix
            N_Bound .- Nodal list of the boundaries of the structure
            Bound .- Boundaries connectivity matrix
        Output:
            Nodes of the initial strut path
        """
        points_1 = np.zeros((len(seeds[:, 0])*len(regions)*2, len(regions) + 2))*1000000
        # points_1[:] = np.nan
        points_1[range(len(seeds)), 0] = seeds[:, 0]
        points_1[range(len(seeds)), 1] = seeds[:, 1]
        points_1[range(len(seeds)), 2:] = len(regions)



        for i_ in range(len(points_1[:, 0])):
            nodo_ = points_1[i_, 0:2]
            last_p = int(sum(points_1[:, 0] < 1000000 ))

            for j_ in range(len(regions)):

                if j_ not in points_1[i_, 2:]:
                    region = regions[j_]
                    polygon = vertices[region]



                    if is_inpolygon(nodo_, polygon, 1) and \
                        (np.isnan(mean_CQ[j_, 0]) == False):

                        i_node = np.array([nodo_[0] - 1000*np.cos(mean_CQ[j_, 0]),
                            nodo_[1] - 1000*np.sin(mean_CQ[j_, 0])])    # Initial node

                        f_node = np.array([nodo_[0] + 1000*np.cos(mean_CQ[j_, 0]),
                            nodo_[1] + 1000*np.sin(mean_CQ[j_, 0])])    # Final node

                        A = intersections_(np.array([[i_node[0], i_node[1]],
                                        [f_node[0], f_node[1]]]),     # Intersections with
                                        [0, 1], vertices, region, 1)    # the Voronoi cell


                        if len(A[:, 0]) > 2:
                            A_ = A
                            A = np.zeros((2, 2))
                            A[0,:] = A_[0,:]
                            A[1,:] = A_[-1,:]


                        B = intersections_(np.array([[i_node[0], i_node[1]],
                                        [f_node[0], f_node[1]]]),     # Intersections with
                                        [0, 1], N_Bound, Bound, 1)    # the Voronoi geometry

                        if (len(B[:, 0]) <= 1) or (len(A[:, 0]) <= 1):
                            A = np.array([[np.nan]])

                        if sum(sum(np.isnan(A))) == 0:
                            if sum(abs(A[0,:]-A[1, 0])) < .001:
                                break
                            else:
                                points_1[i_, j_ + 2] = j_

                                A_ = [False, False]
                                for k_ in range(2):
                                    A_[k_] = is_inpolygon(A[k_,:], N_Bound[Bound,:], 1)

                                if sum(A_) > 0:
                                    last_p = int(sum(np.isnan(points_1[:, 0]) == False))
                                    if last_p < (len(points_1[:, 1]) - 1):
                                        points_1[range(last_p, (last_p + int(sum(A_)))), 0:2] = A[A_,:]
                                        points_1[range(last_p, (last_p + int(sum(A_)))), 2:] = \
                                            np.array([points_1[i_, 2:], ]*sum(A_))





                            # nodo_ = A[1, :]
                            # new_node = sum(np.isnan(points_1[:, 0]) == False)
                            # points_1[new_node, :] =[A[0, 0], A[0, 1], j_]

        return points_1[np.isnan(points_1[:, 0]) == False, 0:2]
        # points_1[650:670, 0:2]


    #==============================================================================
    def strut_path1(seeds, mean_CQ, vertices, regions, N_Bound, Bound):

        """
        Description:
            Proposes the first strut path based on the computed directions and
            Voronoï division (fast version).
        Input:
            seeds .- Seeds to grow the branches
            mena_CQ .- Computed mean direction per zone
            vertices .- Voronoï cells' vertices
            regions .- Cells' connectivity matrix
            N_Bound .- Nodal list of the boundaries of the structure
            Bound .- Boundaries connectivity matrix
        Output:
            Nodes of the initial strut path
        """
        points_1 = np.ones((len(seeds[:, 0])*len(regions)*2, len(regions) + 2))*1000000
        # points_1[:] = np.nan
        points_1[range(len(seeds)), 0] = seeds[:, 0]
        points_1[range(len(seeds)), 1] = seeds[:, 1]
        points_1[range(len(seeds)), 2:] = len(regions)



        for i_ in range(len(points_1[:, 0])):
            nodo_ = points_1[i_, 0:2]    # Initial Point
            last_p = int(sum(points_1[:, 0] < 1000000))

            for j_ in range(len(regions)):

                if j_ not in points_1[i_, 2:]:
                    region = regions[j_]    # Current region
                    polygon = vertices[region]


                    if is_inpolygon(nodo_, polygon, 1) and \
                        (np.isnan(mean_CQ[j_, 0]) == False):

                        i_node = np.array([nodo_[0] - 1000*np.cos(mean_CQ[j_, 0]),
                            nodo_[1] - 1000*np.sin(mean_CQ[j_, 0])])    # Initial node

                        f_node = np.array([nodo_[0] + 1000*np.cos(mean_CQ[j_, 0]),
                            nodo_[1] + 1000*np.sin(mean_CQ[j_, 0])])    # Final node

                        A_ = intersections_(np.array([[i_node[0], i_node[1]],
                                        [f_node[0], f_node[1]]]),     # Intersections with
                                        [0, 1], vertices, region, 1)    # the Voronoi cell
                        A_ = np.around(A_, 4)

                        A_ = unique_local(A_)

                        if np.isnan(A_[0, 0]):
                            A_ = np.array([[10000000, 10000000]])

                        inside = np.zeros((len(A_[:, 0])), dtype = bool)

                        for L_ in range(len(A_[:, 0])):

                            inside[L_] = is_inpolygon(A_[L_,:], N_Bound[Bound,:], 1)

                        A = A_[inside,:]




                        if len(A[:, 0]) > 2:
                            A_ = A
                            A = np.zeros((2, 2))
                            A[0,:] = A_[0,:]
                            A[1,:] = A_[-1,:]


                        B = intersections_(np.array([[i_node[0], i_node[1]],
                                        [f_node[0], f_node[1]]]),     # Intersections with
                                        [0, 1], N_Bound, Bound, 1)    # the Voronoi geometry
                        B = np.around(B, 4)
                        B = unique_local(B)

                        if (len(B[:, 0]) <= 1) or (len(A[:, 0]) <= 1):
                            A = np.array([[np.nan]])

                        if sum(sum(np.isnan(A))) == 0:
                            if sum(abs(A[0,:]-A[1, 0])) < .001:
                                break
                            else:
                                points_1[i_, j_ + 2] = j_

                                A_ = [False, False]
                                for k_ in range(2):
                                    A_[k_] = is_inpolygon(A[k_,:], N_Bound[Bound,:], 1)

                                if sum(A_) > 0:
                                    last_p = int(sum(np.isnan(points_1[:, 0]) == False))
                                    if last_p < (len(points_1[:, 1]) - 1):
                                        points_1[range(last_p, (last_p + int(sum(A_)))), 0:2] = A[A_,:]
                                        points_1[range(last_p, (last_p + int(sum(A_)))), 2:] = \
                                            np.array([points_1[i_, 2:], ]*sum(A_))





                            # nodo_ = A[1, :]
                            # new_node = sum(np.isnan(points_1[:, 0]) == False)
                            # points_1[new_node, :] =[A[0, 0], A[0, 1], j_]

        return points_1[np.isnan(points_1[:, 0]) == False, 0:2]
        # points_1[650:670, 0:2]


    #==============================================================================
    def voronoi_finite_polygons_2d(vc, vr):
        """
        Description:
            Reconstruct infinite voronoi regions in a 2D diagram to finite regions.
        Input:
            vor .- Voronoi
            radius .- float, optional. Distance to 'points at infinity'.
        Output:
            regions .- list of tuples
                Indices of vertices in each revised Voronoi regions.
            vertices .- list of tuples
                Coordinates for revised Voronoi vertices. Same as coordinates
                of input vertices, with 'points at infinity' appended to the
                end.
        """
        new_regions1 = []

        for r in vr:
            new_regions1.append(vr[r])

        new_points = np.zeros((len(vc), 2))
        i_ = 0
        for P1 in vc:
            new_points[i_,:] = P1
            i_ = i_ + 1


        return new_points, new_regions1

    #==============================================================================
    def voronoi_finite_polygons_2d_B(vor, radius=None):
        """
        Description:
            Reconstruct infinite voronoi regions in a 2D diagram to finite regions.
        Input:
            vor .- Voronoi
            radius .- float, optional. Distance to 'points at infinity'.
        Output:
            regions .- list of tuples
                Indices of vertices in each revised Voronoi regions.
            vertices .- list of tuples
                Coordinates for revised Voronoi vertices. Same as coordinates
                of input vertices, with 'points at infinity' appended to the
                end.
        """

        if vor.points.shape[1] != 2:
            raise ValueError("Requires 2D input")

        new_regions = []
        new_vertices = vor.vertices.tolist()

        center = vor.points.mean(axis=0)
        if radius is None:
            radius = vor.points.ptp().max()

        # Construct a map containing all ridges for a given point
        all_ridges = {}
        for (p1, p2), (v1, v2) in zip(vor.ridge_points, vor.ridge_vertices):
            all_ridges.setdefault(p1, []).append((p2, v1, v2))
            all_ridges.setdefault(p2, []).append((p1, v1, v2))

        # Reconstruct infinite regions
        for p1, region in enumerate(vor.point_region):
            vertices = vor.regions[region]

            if all(v >= 0 for v in vertices):
                # finite region
                new_regions.append(vertices)
                continue

            # reconstruct a non-finite region
            ridges = all_ridges[p1]
            new_region = [v for v in vertices if v >= 0]

            for p2, v1, v2 in ridges:
                if v2 < 0:
                    v1, v2 = v2, v1
                if v1 >= 0:
                    # finite ridge: already in the region
                    continue
                # Compute the missing endpoint of an infinite ridge
                t = vor.points[p2] - vor.points[p1] # tangent
                t /= np.linalg.norm(t)
                n = np.array([-t[1], t[0]])  # normal

                midpoint = vor.points[[p1, p2]].mean(axis=0)
                direction = np.sign(np.dot(midpoint - center, n)) * n
                far_point = vor.vertices[v2] + direction * radius

                new_region.append(len(new_vertices))
                new_vertices.append(far_point.tolist())

            # sort region counterclockwise
            vs = np.asarray([new_vertices[v] for v in new_region])
            c = vs.mean(axis=0)
            angles = np.arctan2(vs[:, 1] - c[1], vs[:, 0] - c[0])
            new_region = np.array(new_region)[np.argsort(angles)]

            # finish
            new_regions.append(new_region.tolist())

        return new_regions, np.asarray(new_vertices)


    #==============================================================================
    def ordering(vertices, region):
        """
        Description:
            Sorting clockwise the nodes of a 2D convex polyherdron
        Input:
            vertices .- Nodal list of the polygon
        Output:
            ord_ .- ordered elements
        """
        vertices = vertices[(np.isnan(vertices[:, 0]) != 1),:]
        cent_ = np.mean((vertices[region,:]), axis=0)
        co_ca_a = angle_clockwise(cent_, vertices[region,:])

        ord_ = np.array([x for _, x in sorted(zip(co_ca_a, range(0, len(region))))])
        ord_ = ord_.astype(int)


        return ord_


    #==============================================================================
    def N_o_Comb(n, k):
        """
        Description:
            Computes the number of possible combinations.
        Input:
            n .- Total  umber of elements
            k .- elements per combinations
        Output:
            a .- Total number of combinations

        """
        a = N_o_Permu(n, k) // factorial(k)

        return a


    #==============================================================================
    def N_o_Permu(n, k):
        """
        Description:
            Computes the number of possible permuttations.
        Input:
            n .- Total  umber of elements
            k .- elements per permuttations
        Output:
            b .- Total number of permuttations

        """
        # n = 100; k = 4
        a = range((n - k + 1), (n + 1), 1)
        b = a[0]
        for i_ in range(len(a) - 1):
            b = b*a[i_ + 1]

        return b


    #==============================================================================
    def op_top(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY, Forces, N_o_S, N_S, N_L, percent):
        """
        Description:
            Topology optimisation.  Reduce the quantity of elements contained in a
            connectivity matrix by testing the elimination of a prescribed quantity
            of elements.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
            Mat_prp .- Material proprerties
            Forces .- Forces on the elements
            N_o_S .- Nodes associated to the supports
            N_o_L .- Nodes associated to the loads
            percent .- Percent to test at each iteration
        Output:
            Con_Mat .- Element conectivity matrix (updated)
            E_sections .- Asigned element sections (updated)
            Mat_prp .- Material proprerties (updated)
            Forces .- Forces on the elements (updated)
            N_o_S .- Nodes associated to the supports (updated)
            N_o_L .- Nodes associated to the loads (updated)

        """
        A = np.arange(len(E_sections))
        A = [x for _, x in sorted(zip(E_sections, A), reverse=True)]

        Con_Mat[:, 0] = Con_Mat[A, 0]
        Con_Mat[:, 1] = Con_Mat[A, 1]
        Forces[:] = Forces[A] # [x for _,x in sorted(zip(E_sections, Forces), reverse=True)]
        E_sections[:] = E_sections[A] #[x for _,x in sorted(zip(E_sections, E_sections), reverse=True)]

        IDoF = np.ones((len(GS_nodes[:, 0])*2), dtype = bool)    # Imposssed degrees of freedom
        for i_ in range(len(N_S)):
            if  N_S[i_, 1] == 0:
                IDoF[(N_S[i_, 0] - 1)*2] = False
            if N_S[i_, 2] == 0:
                IDoF[(N_S[i_, 0] - 1)*2 + 1] = False

        Con_Mat, E_sections, Forces = K_matrix1by1(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY,
                                              Forces, IDoF, percent, 0)

        Steady = np.zeros((len(N_S[:, 0]) + len(N_L[:, 0])), dtype = int)

        i_ = 0
        for key in N_o_S.keys():
            Steady[i_] = N_o_S[key]

        GS_nodes, Con_Mat, Steady1 = Erase_nodes(GS_nodes, Con_Mat, Steady)

        i_ = 0
        for key in N_o_S.keys():
            N_o_S[key] = np.array(np.array([Steady1[i_]]), dtype = int)




        return E_sections, Forces, GS_nodes, Con_Mat, N_o_S


    #==============================================================================
    def op_top_node(GS_nodes, Con_Mat, AREAS, Forces, Ec, Es, FC, FY, N_o_S, N_S, N_L,
                    percent, GROUP_S, GROUP_F, INIT_ALEA, percent1):

        """
        Description:
            Topology optimisation.  Reduce the quantity of elements contained in a
            connectivity matrix by testing the elimination of a prescribed quantity
            of elements. Also reduce the groups of elements attached to a node.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
            Mat_prp .- Material proprerties
            Forces .- Forces on the elements
            N_o_S .- Nodes associated to the supports
            N_o_L .- Nodes associated to the loads
            percent .- Percent to test at each iteration
        Output:
            Con_Mat .- Element conectivity matrix (updated)
            E_sections .- Asigned element sections (updated)
            Mat_prp .- Material proprerties (updated)
            Forces .- Forces on the elements (updated)
            N_o_S .- Nodes associated to the supports (updated)
            N_o_L .- Nodes associated to the loads (updated)

        """
        maxTie = max(AREAS[Forces >= 0])
        maxStrut = max(AREAS[Forces < 0])


        A = np.arange(len(AREAS))
        A = [x for _, x in sorted(zip(AREAS, A), reverse=True)]

        Con_Mat[:, 0] = Con_Mat[A, 0]
        Con_Mat[:, 1] = Con_Mat[A, 1]
        Forces[:] = Forces[A] # [x for _,x in sorted(zip(AREAS, Forces), reverse=True)]
        AREAS[:] = AREAS[A] #[x for _,x in sorted(zip(AREAS, AREAS), reverse=True)]

        B = int(len(Con_Mat)*(1-percent1))

        C, D = count_dup((Con_Mat[0:B]).reshape(-1))

        NtoK = C[D > 0]    # Nodes to keep



        Order = np.zeros((len(Con_Mat[:, 0])), dtype = int)
        Order1 = np.zeros((len(Con_Mat[:, 0])), dtype = int)
        Order2 = np.zeros((len(Con_Mat[:, 0])), dtype = int)
        j_1 = 0
        j_2 = 0
        for i_ in range(len(Con_Mat[:, 0])):
            if (Con_Mat[i_, 0] in NtoK) or (Con_Mat[i_, 1] in NtoK):
                Order1[j_1] = i_
                j_1 = j_1 + 1
            else:
                Order2[j_2] = i_
                j_2 = j_2 + 1


        Sort_nodes = np.arange(j_2)


        if not INIT_ALEA:
            random.shuffle(Sort_nodes)
        else:
            random.seed(INIT_ALEA)
            random.shuffle(Sort_nodes)

        Order[0:(j_1)] =  Order1[0:(j_1)]

        Order[j_1::] = Order2[Sort_nodes]



        Con_Mat[:, 0] = Con_Mat[Order, 0]
        Con_Mat[:, 1] = Con_Mat[Order, 1]

        Forces[:] = Forces[Order]
        AREAS[:] = AREAS[Order]




        GS_nodes, Con_Mat, N_o_S, N_S, N_L = Erase_nodes(GS_nodes, Con_Mat, N_o_S, N_S, N_L, GROUP_S, GROUP_F)


        IDoF = np.ones((len(GS_nodes[:, 0])*2), dtype = bool)    # Imposssed degrees of freedom


        for i_ in range(len(N_S)):
            if  N_S[i_, 1] == 0:
                IDoF[int(N_S[i_, 0] - 1)*2] = False
            if N_S[i_, 2] == 0:
                IDoF[int(N_S[i_, 0] - 1)*2 + 1] = False

        Con_Mat, AREAS, Forces = K_matrix1by1(GS_nodes, Con_Mat, AREAS,  Ec, Es, FC, FY,
                                              Forces, IDoF, percent, 0)

        GS_nodes, Con_Mat, N_o_S, N_S, N_L = Erase_nodes(GS_nodes, Con_Mat, N_o_S, N_S, N_L, GROUP_S, GROUP_F)


        return AREAS, Forces, GS_nodes, Con_Mat, N_o_S, N_S, N_L
    #==============================================================================
    def op_size(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY, Forces, N_o_S, min_A, max_change):
        """
        Description:
            Size optimisation. Modifies the individual section of the elements.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
            Mat_prp .- Material proprerties
            Forces .- Forces on the elements
            N_o_S .- Nodes associated to the supports
            min_A .- Minimal section
            max_change .- MAximal admited section change
        Output:
            E_sections .- Asigned element sections
            Conv_ .- Convergence
            V_red .- Volume reduction
        """
        E_sections_i = np.ones([len(Con_Mat[:, 0])])
        V_i = truss_volume(GS_nodes, Con_Mat, E_sections)

        E_sections_up = np.ones([len(E_sections)])
        E_sections_up[:] = E_sections*(1 + max_change)
        E_sections_down = np.ones([len(E_sections)])
        E_sections_down[:] = E_sections*(1 - max_change)

        E_sections_i[Forces > 0] = Forces[Forces > 0] / FY    #Ties' cross sections
        E_sections_i[Forces <= 0] = abs(Forces[Forces <= 0]) / FC    #Struts' cross sections

        E_sections_i[(E_sections_i - E_sections_up) > 0] =  E_sections_up[(E_sections_i - E_sections_up) > 0]
        E_sections_i[(E_sections_i - E_sections_down) < 0] =  E_sections_down[(E_sections_i - E_sections_down) < 0]
        E_sections_i[E_sections_i < min_A] = min_A

        V_f = truss_volume(GS_nodes, Con_Mat, E_sections_i)
        V_red = 100*(V_i - V_f)/V_i

        Conv_ = np.sqrt(np.sum((np.divide(abs(E_sections_i - E_sections), E_sections))**2))
        # print("Iteration %d, Volume reduction %.2F, relatif error E=%.6f" % (i_, V_red, Error_))

        E_sections[:] = E_sections_i

        return E_sections, Conv_, V_red




    #==============================================================================
    def op_global(GS_nodes, Con_Mat, N_o_S, max_iter, min_A, UNITE_MAILLAGE, max_change,
                  Ec, Es, FC, FY, scheme, GC, CONVER2, percent, GROUP_S, GROUP_F, INIT_ALEA, __GROUP_S, __GROUP_F):

        """
        Description:
            Global optimisation. Performs the optimisations.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
            Mat_prp .- Material proprerties
            Forces .- Forces on the elements
            N_o_S .- Nodes associated to the supports
            N_o_L .- Nodes associated to the loads
            r .- Radious of research
            Weight .- Nodes to modify
            directory
            max_iter .- Maximum number of iterations
            scheme .- Scheme of optimisation [1 2 or 3]
            GC .- Global convergence
            percent .- percento to erase for the topology optimisation

        """
        Elem_prin = int(    # Number of elements to erase
                round((1. - percent)*len(Con_Mat[:, 0]), 0))



        j_ = 0
        Title_ = 'S'

        number = 0
        for key in __GROUP_S.keys():
            AB = N_o_S[key]
            number = number + len(AB)

        # print(__GROUP_S,number)
        N_S = np.zeros((number, 3))

        for key in __GROUP_S.keys():
            AB = GROUP_S[key]
            S1 = N_o_S[key]
            if len(S1) > 1:

                for i in range(len(S1)):
                    N_S[j_, 1::] = AB.astype(float)
                    N_S[np.isnan(N_S)] = 10e9
                    N_S[j_, 0] = int(S1[i])
                    j_ = j_ + 1


            else:

                N_S[j_, 1::] = AB.astype(float)
                N_S[np.isnan(N_S)] = 10e9
                N_S[j_, 0] = int(N_o_S[key])
                j_ = j_ + 1
        # N_S[np.isnan(N_S)] = 1


        number = 0
        for key in __GROUP_F.keys():
            AB = __GROUP_F[key]
            number = number + len(AB)

        j_ = 0
        N_L = np.zeros((len(GROUP_F.keys()), 3))
        for key in GROUP_F.keys():
            S1 = GROUP_F[key]
            S2 = N_o_S[key]

            try:
                for i in range(len(N_o_S[key])):
                    N_L[j_, 1::] = S1[i,:]
                    N_L[j_, 0] = int(S2[i])
                    j_ = j_ + 1

            except:
                N_L[j_, 1::] = GROUP_F[key]
                N_L[j_, 0] = int(N_o_S[key])
                j_ = j_ + 1


        E_sections = np.ones([len(Con_Mat[:, 0])])    # Initial cross sections
        __Forces = np.ones([len(Con_Mat[:, 0])])    # and forces
        s = 0

        for i_ in range(1, max_iter):
            # print ('iteration %d' % i_)
            # E_sections_i = np.ones([len(Con_Mat[:, 0])])
            # V_i = truss_volume(GS_nodes, Con_Mat, E_sections)

            if i_ <= 200: # Generate the geometry

                ST_MESH = mesh_create2(GS_nodes, Con_Mat, N_o_S, __Forces, Title_, UNITE_MAILLAGE, __GROUP_S, __GROUP_F)

                UL = UniteAster()
                nomFichierSortie = UL.Nom(UNITE_MAILLAGE)
                fproc = open(nomFichierSortie, 'w')
                fproc.write(os.linesep.join(ST_MESH))
                fproc.close()
                UL.EtatInit(UNITE_MAILLAGE)
                # med_create(directory)


            __Forces = run_truss_computation_(i_, GS_nodes, Con_Mat, E_sections,
                                             __Forces, N_o_S, Ec, Es, FC, FY, N_S, N_L, UNITE_MAILLAGE)


            if sum(__Forces) == 0:
                E_sections = A_i
                GS_nodes = GS_i
                __Forces = F_i
                N_o_S = NoS_i
                N_o_L = NoL_i
                UTMESS('F', 'CALCBT_6')

                break

            E_sections, Conv_, V_red  = op_size(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY,
                                                  __Forces, N_o_S, min_A, max_change)


            # print("Iteration %d, Volume reduction ratio %.2F, convergence C=%.6f" % (i_, V_red, Conv_))

            if scheme == 'TOPO' and Conv_ <= 13.3*GC:


                if s == 2:
                    break

                A_i = np.zeros((len(E_sections)))
                A_i[:] = E_sections
                GS_i = np.zeros((len(GS_nodes), 2))
                GS_i[:] = GS_nodes
                F_i = np.zeros((len(__Forces)))
                F_i[:] = __Forces
                Co_i = np.zeros((len(Con_Mat), 2))
                Co_i[:] = Con_Mat
                NoS_i = N_o_S
                # NoL_i = np.zeros((len(N_o_L), 4)); NoL_i[:] = N_o_L



                E_sections, __Forces, GS_nodes, Con_Mat, N_o_S, N_S, N_L = op_top_node(GS_nodes,
                                Con_Mat, E_sections, __Forces, Ec, Es, FC, FY, N_o_S, N_S, N_L, Elem_prin,
                                GROUP_S, GROUP_F, INIT_ALEA, percent)


                j_ = 0
                N_S = np.zeros((len(N_S[:, 0]), 3))
                for key in GROUP_S.keys():
                    AB = GROUP_S[key]
                    if len(AB) <= 1:
                        N_S[j_, 1::] = AB.astype(float)
                        N_S[np.isnan(N_S)] = 10e9
                        N_S[j_, 0] = int(N_o_S[key])
                        j_ = j_ + 1
                    else:
                        BC = N_o_S[key]
                        for i_ in range(len(BC)):
                            N_S[j_, 1::] = AB.astype(float)
                            N_S[np.isnan(N_S)] = 10e9
                            N_S[j_, 0] = int(BC[i_])
                            j_ = j_ + 1





                j_ = 0
                N_L = np.zeros((len(GROUP_F.keys()), 3))
                for key in GROUP_F.keys():
                    N_L[j_, 1::] = GROUP_F[key]
                    N_L[j_, 0] = int(N_o_S[key])
                    j_ = j_ + 1


                ST_MESH = mesh_create2(GS_nodes, Con_Mat, N_o_S, __Forces, Title_, UNITE_MAILLAGE, __GROUP_S,
                                        __GROUP_F)


                UNITE_MAILLAGE = mm.ToAster()


                UL = UniteAster()
                nomFichierSortie = UL.Nom(UNITE_MAILLAGE)
                fproc = open(nomFichierSortie, 'w')
                fproc.write(os.linesep.join(ST_MESH))
                fproc.close()
                UL.EtatInit(UNITE_MAILLAGE)


                __Forces = run_truss_computation_(i_, GS_nodes, Con_Mat, E_sections, __Forces, N_o_S, Ec, Es, FC, FY, N_S, N_L, UNITE_MAILLAGE)


            if Conv_ <= GC:
                break

        if (Conv_ > GC) and (i_ >= (max_iter-1)):
            UTMESS('F', 'CALCBT_7')

        E_length = Length_(GS_nodes, Con_Mat)

        __Forces = np.ones([len(Con_Mat[:, 0])])
        ST_MESH = mesh_create2(GS_nodes, Con_Mat, N_o_S, __Forces, Title_, UNITE_MAILLAGE, __GROUP_S, __GROUP_F)
        UNITE_MAILLAGE = mm.ToAster()


        UL = UniteAster()
        nomFichierSortie = UL.Nom(UNITE_MAILLAGE)
        fproc = open(nomFichierSortie, 'w')
        fproc.write(os.linesep.join(ST_MESH))
        fproc.close()
        UL.EtatInit(UNITE_MAILLAGE)
        __Forces, __resu, __truss, __strainE = run_truss_computation_1(i_, GS_nodes, Con_Mat, E_sections, __Forces,
                                                                        N_o_S, Ec, Es, FC, FY, N_S, N_L, UNITE_MAILLAGE)



        E_sections, Conv_, V_red  = op_size(GS_nodes, Con_Mat, E_sections,  Ec, Es, FC, FY,
                                                  __Forces, N_o_S, min_A, max_change)
        # Output table
        ST_System = {}
        __element = []
        __type = []
        noS = 1    # Number of struts in the system
        noT = 1    # Number of Ties in the system

        E_elem = np.ones(len(__Forces))*Ec
        E_elem[__Forces >= 0] =  Es
        E_Energy = np.divide(np.multiply(__Forces, __Forces), np.divide(np.multiply(E_sections, E_elem), E_length))

        # print 'i   j    Force    length   Section   Material'
        for i_ in range(len(E_sections)):
            if __Forces[i_] > 0:
                Nature = 'TIRANT'
                __type.append('TIRANT')
                __element.append('T%d' % noS)
                noS = noS + 1

            else:
                Nature = 'BIELLE'
                __type.append('BIELLE')
                __element.append('S%d' % noT)
                noT = noT + 1

            Q = [(' %d      %d        %.2f' % (Con_Mat[i_, 0], Con_Mat[i_, 1], __Forces[i_]) + '  %.2f ' % (E_length[i_]) + ' '*(16 - count_digit(__Forces[i_])) + ' %.5f       %s' % (E_sections[i_], Nature))]

            ST_System[i_] = Q


        TABLE = CREA_TABLE(
                LISTE=(
                        _F(LISTE_R= ar2tuple(GS_nodes[Con_Mat[:, 0], 0]),
                            PARA='COORD_X NOEUD_I'
                        ),
                        _F(LISTE_R= ar2tuple(GS_nodes[Con_Mat[:, 0], 1]),
                            PARA='COORD_Y NOEUD_I'
                        ),
                        _F(LISTE_R= ar2tuple(GS_nodes[Con_Mat[:, 1], 0]),
                            PARA='COORD_X NOEUD_J'
                        ),
                        _F(LISTE_R= ar2tuple(GS_nodes[Con_Mat[:, 1], 1]),
                            PARA='COORD_Y NOEUD_J'
                        ),
                        _F(LISTE_K= tuple(__type),
                            PARA='TYPE'
                        ),
                        _F(LISTE_R= ar2tuple(__Forces),
                            PARA='N'
                        ),
                        _F(LISTE_R= ar2tuple(E_sections),
                            PARA='A'
                        ),
                        _F(LISTE_R= ar2tuple(E_length),
                            PARA='L'
                        ),
                        _F(LISTE_R= ar2tuple(E_Energy),
                            PARA='ENEL_ELEM'
                        )),
                # TITRE='ST_Model'
                        )

        return GS_nodes, Con_Mat, E_sections, __Forces, __resu, TABLE


    #==============================================================================
    def Peaks_n_Valleys(x, y):
        """

        """
        data = y[np.isnan(y) != 1]    # Avoiding NAN values
        data_1 = np.zeros(len(data) + 2)
        data_1[[0, -1]] = data[[1, -2]]
        data_1[1: -1] = data    # 1st and last values (always peak/valledef y)
        P_V = np.zeros(len(y))
        if len(y[np.isnan(y) != 1]) != 0: # Forward\backward-derivatives
            P_V[np.isnan(y) != 1] = np.diff(np.sign(np.diff(data_1)))
            P_V[P_V == 2] = 1     # 1=valley; -2=peak
        return P_V

    #==============================================================================
    def red_ang_disp(ang):

        """

        """
        ang = ang[np.isnan(ang) == False]
        ad_1 = np.max(ang) - np.min(ang)

        ang_2 = np.zeros((len(ang), 1))
        ang_2 = ang
        ang_2[ang > pi] = ang_2[ang > pi] - pi
        ad_2 = np.max(ang_2) - np.min(ang_2)

        ang_3 = np.zeros((len(ang), 1))
        ang_3 = ang
        ang_3[ang > 3*pi/2] = ang_3[ang > 3*pi/2] - pi
        ang_3[ang < pi/2] = ang_3[ang < pi/2] + pi
        ad_3 = np.max(ang_3) - np.min(ang_3)

        if ad_1 == min(ad_1, ad_2, ad_3):
            return ang
        elif ad_2 == min(ad_1, ad_2, ad_3):
            return ang_2
        elif ad_3 == min(ad_1, ad_2, ad_3):
            return ang_3

    #==============================================================================
    def read_from(directory, iteration_, Con_Mat):
        """
        Description:
            Reading data form a specified directory.
        Input:
            directory
            iteration_ .- Iteration number to built the File title
            Con_Mat_ .- Expected length of the data
        Output:
            Forces .- Read data
        """
        Forces = np.zeros([len(Con_Mat[:, 0])])
        newpath = directory + '/aster_model/'
        if not os.path.exists(newpath):
            os.makedirs(newpath)

        if os.path.exists(newpath + 'RESULTS_%d' % iteration_) == True:

            with open(newpath + 'RESULTS_%d' % iteration_) as fp:
                line = fp.readline()
                cnt = 1
                i_ = 0
                while line and (i_ < len(Con_Mat[:, 0])) :
                    if line.strip():
                        A = line[8]
                        if A.isdigit():
                            # line = line.replace("+", "0")
                            Forces[i_] = float(line[10:32]) + 1
                            i_ = i_ + 1
                    line = fp.readline()
                    cnt += 1

            return Forces

        else:
            # print('Aborted at iteration %d' % (iteration_))
            return np.array(([0]))


    #===============================================================================
    def run_truss_computation_1(iteration_, GS_nodes, Con_Mat, __S, Forces, N_o_S,  Ec, Es, FC, FY, N_S, N_L,
                                UNITE_MAILLAGE):
        """
        Description:
            Performs the static analysis of the struts-ties structure
            considering only self weight (gravity load)
        Input:def _bc
            iteration_ .- number of the current iteration
            GS_nodes .- Nodal list of the ground structure
            Con_Mat .- Connectivity matrix of the ground structure
            __S .- Cross sections
            Forces .- Forces computed at the last iteration
            N_o_L .- Nodes to be loaded
            N_o_S .- Nodes to be restrained
            Mat_prp .- Characteristics of the used Mat_prperials
        Output:
            Array containing the forces of all bar in the model
        """

        __truss = LIRE_MAILLAGE(FORMAT='ASTER',
                        UNITE=UNITE_MAILLAGE)

        __truss = DEFI_GROUP(reuse=__truss,
                      MAILLAGE=__truss,
                      CREA_GROUP_MA=_F(NOM='tutte', TOUT='OUI'),
                INFO=2
                      )

        __model = AFFE_MODELE(MAILLAGE=__truss,
                      AFFE=(
                      _F(GROUP_MA='tutte', MODELISATION='2D_BARRE', PHENOMENE='MECANIQUE')
                      )
                  )

        __NE = len(Con_Mat[:, 0])    # Number of elements

        # Assign rectangular sections to all elements
        H = 'H'
        RECTANGLE = 'RECTANGLE'
        __group = []

        for i_ in range(__NE):
            __group = __group + [('EG_%d' % (i_+1))]

        motscles = {}
        motscles['BARRE'] = []

        for i_ in range(__NE):
            if (i_ + 1) == __NE:
                motscles['BARRE'].append(_F(CARA=H, GROUP_MA=__group[i_], SECTION=RECTANGLE, VALE=__S[i_]))
                #% (i_ + 1, __S[i_])]

            else:
                motscles['BARRE'].append(_F(CARA=H, GROUP_MA=__group[i_], SECTION=RECTANGLE, VALE=__S[i_]),)
                # motscles["BARRE"] =  motscles["BARRE"] + \
                #[('_F(CARA=(\'H\'), GROUP_MA=(\'EG_%d\'), SECTION=\'RECTANGLE\', VALE=(%.8f)),')
                #% (i_ + 1, __S[i_])]

        # Assigning sections
        __carael = AFFE_CARA_ELEM(MODELE=__model,**motscles)



        # Assigning materials
        #__materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, ))), MAILLAGE=__truss)


        if sum(Forces > 0) == len(Forces):
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, )),),
                            MAILLAGE=__truss)

        elif sum(Forces <= 0) == len(Forces):
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Struts', ), MATER=(__steel, )),),
                            MAILLAGE=__truss)
        else:
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, )),
                            _F(GROUP_MA=('Struts', ), MATER=(__concre, ))),
                            MAILLAGE=__truss)



        BC1 = {}

        __group = []

        for i_ in range(len(N_L[:, 0])):
            __group = __group + [('LOAD_%d' % (i_ + 1))]

        BC1['FORCE_NODALE'] = []

        for i_ in range(len(N_L[:, 0])):
            if i_ == (len(N_L[:, 0]) - 1):
                BC1['FORCE_NODALE'].append(_F(FX=N_L[i_, 1], FY=N_L[i_, 2], GROUP_NO=__group[i_]))

            else:
                BC1['FORCE_NODALE'].append(_F(FX=N_L[i_, 1], FY=N_L[i_, 2], GROUP_NO=__group[i_]),)

        __group = []
        for i_ in range(len(N_S[:, 0])):
            __group = __group + [('SUP_%d' % (i_ + 1))]

        BC1['DDL_IMPO'] = []

        for i_ in range(len(N_S[:, 0])):
            if i_ == (len(N_S[:, 0]) - 1):
                if (N_S[i_, 1] < 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], DY=N_S[i_, 2], GROUP_NO=__group[i_]))

                elif (N_S[i_, 1] < 10e9) and (N_S[i_, 2] == 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], GROUP_NO=__group[i_]))

                elif (N_S[i_, 1] == 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DY=N_S[i_, 2], GROUP_NO=__group[i_]))

            else:
                if (N_S[i_, 1] < 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], DY=N_S[i_, 2], GROUP_NO=__group[i_]),)

                elif (N_S[i_, 1] < 10e9) and (N_S[i_, 2] == 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], GROUP_NO=__group[i_]),)

                elif (N_S[i_, 1] == 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DY=N_S[i_, 2], GROUP_NO=__group[i_]),)




        # Boundary conditions
        __bc = AFFE_CHAR_MECA(MODELE=__model, **BC1)


        # Solve static case


        __resu = MECA_STATIQUE(CARA_ELEM=__carael, CHAM_MATER=__materi, EXCIT=_F(CHARGE=__bc,
                TYPE_CHARGE='FIXE_CSTE'), MODELE=__model)

        #__resu2 = CALC_CHAMP(ENERGIE=('ENEL_ELEM', ),RESULTAT=__resu)

        __resu = CALC_CHAMP(reuse=__resu, CONTRAINTE=('EFGE_ELGA', ), RESULTAT=__resu)


        __EFA = CREA_CHAMP(
            NOM_CHAM='EFGE_ELGA',
            OPERATION='EXTR',
            RESULTAT=__resu,
            TYPE_CHAM='ELGA_SIEF_R')


        __forc_i = __EFA.EXTR_COMP('N', [], 0)

        a = __forc_i.valeurs


        return a, __resu, 1, 1





    #===============================================================================
    def run_truss_computation_(iteration_, GS_nodes, Con_Mat, __S, Forces, N_o_S,  Ec, Es, FC, FY, N_S, N_L, UNITE_MAILLAGE):
        """
        Description:
            Performs the static analysis of the struts-ties structure
            considering only self weight (gravity load)
        Input:def _bc
            iteration_ .- number of the current iteration
            GS_nodes .- Nodal list of the ground structure
            Con_Mat .- Connectivity matrix of the ground structure
            __S .- Cross sections
            Forces .- Forces computed at the last iteration
            N_o_L .- Nodes to be loaded
            N_o_S .- Nodes to be restrained
            Mat_prp .- Characteristics of the used Mat_prperials
        Output:
            Array containing the forces of all bar in the model
        """

        __truss = LIRE_MAILLAGE(FORMAT='ASTER',
                        UNITE=UNITE_MAILLAGE)

        __truss = DEFI_GROUP(reuse=__truss,
                      MAILLAGE=__truss,
                      CREA_GROUP_MA=_F(NOM='tutte', TOUT='OUI'),
                INFO=2
                      )

        __model = AFFE_MODELE(MAILLAGE=__truss,
                      AFFE=(
                      _F(GROUP_MA='tutte', MODELISATION='2D_BARRE', PHENOMENE='MECANIQUE')
                      )
                  )

        __NE = len(Con_Mat[:, 0])    # Number of elements

        # Assign rectangular sections to all elements
        H = 'H'
        RECTANGLE = 'RECTANGLE'
        __group = []

        for i_ in range(__NE):
            __group = __group + [('EG_%d' % (i_+1))]

        motscles = {}
        motscles['BARRE'] = []

        for i_ in range(__NE):
            if (i_ + 1) == __NE:
                motscles['BARRE'].append(_F(CARA=H, GROUP_MA=__group[i_], SECTION=RECTANGLE, VALE=__S[i_]))
                #% (i_ + 1, __S[i_])]

            else:
                motscles['BARRE'].append(_F(CARA=H, GROUP_MA=__group[i_], SECTION=RECTANGLE, VALE=__S[i_]),)
                # motscles["BARRE"] =  motscles["BARRE"] + \
                #[('_F(CARA=(\'H\'), GROUP_MA=(\'EG_%d\'), SECTION=\'RECTANGLE\', VALE=(%.8f)),')
                #% (i_ + 1, __S[i_])]

        # Assigning sections
        __carael = AFFE_CARA_ELEM(MODELE=__model,**motscles)



        # Assigning materials
        #__materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, ))), MAILLAGE=__truss)

        if sum(Forces > 0) == len(Forces):
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, )),),
                            MAILLAGE=__truss)
        elif sum(Forces <= 0) == len(Forces):
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Struts', ), MATER=(__steel, )),),
                            MAILLAGE=__truss)
        else:
            __materi = AFFE_MATERIAU(AFFE=(_F(GROUP_MA=('Ties', ), MATER=(__steel, )),
                            _F(GROUP_MA=('Struts', ), MATER=(__concre, ))),
                            MAILLAGE=__truss)



        BC1 = {}

        __group = []

        for i_ in range(len(N_L[:, 0])):
            __group = __group + [('LOAD_%d' % (i_ + 1))]

        BC1['FORCE_NODALE'] = []

        for i_ in range(len(N_L[:, 0])):
            if i_ == (len(N_L[:, 0]) - 1):
                BC1['FORCE_NODALE'].append(_F(FX=N_L[i_, 1], FY=N_L[i_, 2], GROUP_NO=__group[i_]))

            else:
                BC1['FORCE_NODALE'].append(_F(FX=N_L[i_, 1], FY=N_L[i_, 2], GROUP_NO=__group[i_]),)

        __group = []
        for i_ in range(len(N_S[:, 0])):
            __group = __group + [('SUP_%d' % (i_ + 1))]

        BC1['DDL_IMPO'] = []

        for i_ in range(len(N_S[:, 0])):
            if i_ == (len(N_S[:, 0]) - 1):
                if (N_S[i_, 1] < 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], DY=N_S[i_, 2], GROUP_NO=__group[i_]))

                elif (N_S[i_, 1] < 10e9) and (N_S[i_, 2] == 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], GROUP_NO=__group[i_]))

                elif (N_S[i_, 1] == 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DY=N_S[i_, 2], GROUP_NO=__group[i_]))

            else:
                if (N_S[i_, 1] < 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], DY=N_S[i_, 2], GROUP_NO=__group[i_]),)

                elif (N_S[i_, 1] < 10e9) and (N_S[i_, 2] == 10e9):
                    BC1['DDL_IMPO'].append(_F(DX=N_S[i_, 1], GROUP_NO=__group[i_]),)

                elif (N_S[i_, 1] == 10e9) and (N_S[i_, 2] < 10e9):
                    BC1['DDL_IMPO'].append(_F(DY=N_S[i_, 2], GROUP_NO=__group[i_]),)



        # Boundary conditions
        __bc = AFFE_CHAR_MECA(MODELE=__model, **BC1)


        # Solve static case


        __resu1 = MECA_STATIQUE(CARA_ELEM=__carael, CHAM_MATER=__materi, EXCIT=_F(CHARGE=__bc,
                TYPE_CHARGE='FIXE_CSTE'), MODELE=__model)

        #__resu2 = CALC_CHAMP(ENERGIE=('ENEL_ELEM', ),RESULTAT=__resu)

        __resu1 = CALC_CHAMP(reuse=__resu1, CONTRAINTE=('EFGE_ELGA', ), RESULTAT=__resu1)



        __EFA = CREA_CHAMP(
            NOM_CHAM='EFGE_ELGA',
            OPERATION='EXTR',
            RESULTAT=__resu1,
            TYPE_CHAM='ELGA_SIEF_R')


        __forc_i = __EFA.EXTR_COMP('N', [], 0)

        a = __forc_i.valeurs

        DETRUIRE(
                  CONCEPT=_F(
                            NOM=(__resu1, __EFA, __carael)
                            )
                )

        return a


    #==============================================================================
    def second_elem(Nonodes):
        """
        Description:
            Creates elements by linking 2 nodes of a nodal matrix.
        Input:
            Nonodes .- Nodal matrix
        Output:
            Connectivity matrix

        """
        PP = N_o_Comb(len(Nonodes[:, 0]), 2)    # Possible permutations
        Links_ = np.zeros((PP, 2))
        Links_[:] = np.nan

        for i_ in range(len(Nonodes[:, 1])):    #Final node
            last_p = int(sum(np.isnan(Links_[:, 1]) == False))
            Links_[last_p:(last_p + len(Nonodes[:, 1]) - i_ - 1), 1] = \
                range(i_ + 1, len(Nonodes[:, 1]))

        for i_ in range(len(Nonodes[:, 0])):    #Initial node
            last_p = int(sum(np.isnan(Links_[:, 0]) == False))
            Links_[last_p:(last_p + len(Nonodes[:, 0]) - i_ - 1), 0] = i_

        return Links_.astype(int)


    #==============================================================================
    def truss_volume(Nodes, Con_Mat, E_sections):
        """
        Description:
            Computes the current volume of the truss.
        Input:
            GS_nodes .- Element nodal list
            Con_Mat .- Element conectivity matrix
            E_sections .- Asigned element sections
        Output:
            Volume of the structure
        """
        Bar_vol = np.multiply(Length_(Nodes, Con_Mat), E_sections)

        return sum(Bar_vol)


    #==============================================================================
    def weight_(GS_nodes, Nodes_, SUPPORTS) :
        """
        Description:
            Computes the weight given to a node. 1 if associated to the boundary
            conditions, 0 otherwise.
        """
        weight = np.zeros((len(GS_nodes[:, 1])), dtype=int)

        coord_ = np.zeros((len(SUPPORTS[:, 0]), 2))

        for i_ in range(len(SUPPORTS[:, 0])):    # Coordinates of the supports
            coord_[i_,:] = Nodes_[int(SUPPORTS[i_, 0] - 1), 1:3]


        for i_ in range(len(GS_nodes[:, 1])):
            if sum(np.all(coord_ == GS_nodes[i_,:], axis=1)) >= 1:
                weight[i_] = True

        return weight


    """
    Core subroutines
    """
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Reading base's mesh
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    def input_results(BASE, __STRESS):
        """

        """
        b = BASE.sdj.COORDO.VALE.get()    # Nodal list
        c = BASE.sdj.CONNEX.get()    #Connectivity matrix


        __Nodes = np.zeros((int(len(b)/3), 4))


        for i in range(len(__Nodes[:, 0])):
            __Nodes[i, 0] = i + 1
            # print(__Nodes[i, 1::])
            # print(b[i*3: i*3 + 3])
            __Nodes[i, 1::] = b[i*3: i*3 + 3]

        __Elements = np.zeros((len(c.keys()), 10))
        __i = 0

        for key in c.keys():
            if len(c[key][:]) == 4:
                __Elements[__i, 6::] = c[key][:]
                __Elements[__i, 0] = __i + 1
                __i = __i + 1

        __Elements = __Elements[__Elements[:, 0] > 0,:]

        __S3 = __STRESS.EXTR_COMP('PRIN_1', [], 0)
        __S2 = __STRESS.EXTR_COMP('PRIN_2', [], 0)

        __S1 = __STRESS.EXTR_COMP('PRIN_3', [], 0)

        __COS = __STRESS.EXTR_COMP('VECT_1_X', [], 0)
        __SIN = __STRESS.EXTR_COMP('VECT_2_X', [], 0)

        __c = __S3.valeurs
        __b = __S2.valeurs
        __a = __S1.valeurs

        p_n_stress = np.zeros((len(__a), 6))
        p_n_stress[:, 1] = __a
        p_n_stress[:, 2] = __b
        p_n_stress[:, 3] = __c


        __COS = __STRESS.EXTR_COMP('VECT_1_X', [], 0)
        __SIN = __STRESS.EXTR_COMP('VECT_1_Y', [], 0)


        __U = __COS.valeurs
        __V = __SIN.valeurs



        return __Nodes, __Elements.astype(int), p_n_stress, __U, __V


    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Local Maxima
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    def local_pnv(Nodes_, p_n_stress, x_d, __PAS_ITERPOL_X, y_d, __PAS_ITERPOL_Y, __Holes):
        """
        Local peaks and valleys

        """

        grid_x, grid_y, grid_I = grid_interp(Nodes_[:, 1:3], p_n_stress[:, 1], __PAS_ITERPOL_X, __PAS_ITERPOL_Y,
                                 __Holes, __Nodes)
        P_S_I, V_S_I = local_max(grid_x, grid_y, grid_I)

        grid_x, grid_y, grid_III = grid_interp(Nodes_[:, 1:3], p_n_stress[:, 3], __PAS_ITERPOL_X,
                                 __PAS_ITERPOL_Y, __Holes, __Nodes)
        P_S_III, V_S_III = local_max(grid_x, grid_y, grid_III)


        L_M = unique_local(np.concatenate((P_S_I, V_S_III), axis=0))

        return L_M, P_S_I, V_S_III


    #==============================================================================
    def unique_local(matrix_):
        """

        """
        if len(matrix_[0,:]) == 1:
            return matrix_
        else:
            matrix_2 = np.ones((len(matrix_[:, 0]), 2))*1000000
            # matrix_2[:] = np.nan
            for i_ in range(len(matrix_[:, 0])):
                a = matrix_[i_, 0]
                b = matrix_[i_, 1]
                c = sum(np.multiply(matrix_2[:, 0] == a, matrix_2[:, 1] == b))

                if c == 0:
                    matrix_2[i_, 0] = a
                    matrix_2[i_, 1] = b

            return matrix_2[matrix_2[:, 0] < 1000000,:]





    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Voronoi and clipped Voronoi division
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def Geometry_div(N_Bound, Bound, Holes, L_M, Nodes_, SUPPORTS, __FORCES, tolerance):
        """

        """
        from Utilitai.voronoi_local import Voronoi

        int_nodes = np.zeros((len(SUPPORTS[:, 0])+len(__FORCES[:, 0]), 4))
        int_nodes[0:len(SUPPORTS[:, 0]),:] = SUPPORTS
        int_nodes[(len(SUPPORTS[:, 0])+1)::,:] = __FORCES

        W_ = weight_(L_M, Nodes_, int_nodes)


        L_M = merge_nodes(L_M, tolerance, W_)



        n = 0


        if len(Holes) > 0:
            for key in Holes.keys():

                n = n + len(Holes[key])


        A = np.zeros((n))
        if len(Holes) > 0:
            for key in Holes.keys():

                A[sum(A > 0):len(Holes[key])] = Holes[key]



        if len(Holes) > 0:
            points_d2 = double_nodes(N_Bound, A, L_M, 0.0001, 0)
            points_d1 = double_nodes(N_Bound, Bound, L_M, 0.0001, 0)
            vc, vr = Voronoi(unique_local(np.concatenate((points_d1, points_d2), axis=0)))

        else:
            points_d1 = double_nodes(N_Bound, Bound, L_M, 0.0001, 0)
            vc, vr = Voronoi(np.concatenate((points_d1, Nodes_[__FORCES[:, 0]-1, 1:3]), axis=0))

        vertices, regions = voronoi_finite_polygons_2d(vc, vr)


        return regions, vertices


    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Initial strut path
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def ini_s_path(Nodes_, U, V, SUPPORTS, __FORCES, vertices, regions, V_S_III, Opt1, N_Bound, Bound ):
        """
        Opt1 .- 0 Considering only pics that also correspond to the boundary conditions
                1 Considering all the pics
        """
        mean_CQ = angle_mean(Nodes_, U, V, vertices, regions)

        int_nodes = np.zeros((len(SUPPORTS[:, 0])+len(__FORCES[:, 0]), 4))
        int_nodes[0:len(SUPPORTS[:, 0]),:] = SUPPORTS
        int_nodes[(len(SUPPORTS[:, 0]) + 1)::,:] = __FORCES



        if Opt1 == 1:
            N_path = strut_path1(V_S_III, mean_CQ, vertices, regions, N_Bound, Bound)

        elif Opt1 == 0:
            coord_ = np.zeros((len(int_nodes[:, 0]), 2))

            for i_ in range(len(int_nodes[:, 0])):
                coord_[i_,:] = Nodes_[int_nodes[i_, 0] - 1, 1:3]

            N_path = strut_path1(coord_, mean_CQ, vertices, regions, N_Bound, Bound)



        return N_path

    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Secondary elements
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def second_(N_Bound, Bound, Nodes_, SUPPORTS, __FORCES, N_path, V_S_III, P_S_I,
                Holes, Leng_max, tolerance, Opt1, __CORNERS):

        """

        """
        if Opt1 == 1:
            GS_nodes = unique_local(np.round(np.concatenate((N_path, P_S_I, V_S_III, Nodes_[__CORNERS, 1:3],
                                                             Nodes_[__FORCES[:, 0]-1, 1:3]), axis = 0), 3))

        elif Opt1 == 0:
            GS_nodes = unique_local(np.round(np.concatenate((N_path, P_S_I, Nodes_[__CORNERS, 1:3],
                                                             Nodes_[__FORCES[:, 0]-1, 1:3]), axis = 0), 3))


        W_ = weight_(GS_nodes, Nodes_, SUPPORTS+1)

        if tolerance != 0:
            GS_nodes = merge_nodes(GS_nodes, tolerance, W_)    # Merge nodes


        Con_Mat = second_elem(GS_nodes)    # Create secondary elements


        Leng_ = Length_(GS_nodes, Con_Mat)
        Con_Mat = Con_Mat[Leng_ <= Leng_max,:]

        if len(Holes) > 0:    #Avoiding elements crossing trimmed sections
            A = erase_el(GS_nodes, Con_Mat, Nodes_, Holes)
            Con_Mat = Con_Mat[A,:]


        GE_plot = np.zeros((len(Con_Mat[:, 0])*3, 2))
        GE_plot[:] = np.nan
        GE_plot[range(0, len(GE_plot[:, 0]), 3),:] = GS_nodes[Con_Mat[:, 0],:]
        GE_plot[range(1, len(GE_plot[:, 0]), 3),:] = GS_nodes[Con_Mat[:, 1],:]



        #[N_o_S, N_o_L] = BCA(Nodes_, GS_nodes, SUPPORTS, LOADS)

        N_o_S = BCA2(Nodes_, GS_nodes, __SUPPORTS)

        return GS_nodes, N_o_S, Con_Mat








    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # Geometry contour
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    def SKIN(__grma, __Nodes, __SUPPORTS_KEY, __FORCES_KEY, GROUP_C):
        """

        """
        motscles = {}
        motscles1 = {}
        motscles['CREA_GROUP_NO'] = []
        motscles1['DETR_GROUP_NO'] = []

        __A = []
        for i_, key in zip(range(len(GROUP_C.keys())), GROUP_C.keys()) :
            if  i_ == 0:
                b = 1
            else:
                b = 0

            if (i_ + 1) == len(GROUP_C.keys()):    # Contour nodal group
                motscles['CREA_GROUP_NO'].append(_F(GROUP_MA=(GROUP_C[key], ), NOM=GROUP_C[key], OPTION='NOEUD_ORDO', ORIGINE='SANS'))
                __A.append(GROUP_C[key],)
                #% (i_ + 1, __S[i_])]

            elif (i_ + 1) < len(GROUP_C.keys()):
                motscles['CREA_GROUP_NO'].append(_F(GROUP_MA=(GROUP_C[key], ), NOM=GROUP_C[key], OPTION='NOEUD_ORDO', ORIGINE='SANS'),)
                __A.append(GROUP_C[key])

        motscles1['DETR_GROUP_NO'].append(_F(NOM=(__A)),)
        # Defining nodal groups
        __SKIN = DEFI_GROUP(reuse=__MAIL, MAILLAGE=__MAIL,**motscles)

        # Updating mail_py
        mm = partition.MAIL_PY()
        mm.FromAster(__MAIL)
        __grno = mm.gno


        Bound = np.array([])
        Holes = {}
        i_ = 1
        for key in GROUP_C.keys():
            if (key ==  0):
                Bound = Cr_loop(__grno[GROUP_C[key]])

            else :
                Holes[key] = Cr_loop(__grno[GROUP_C[key]])
                i_ = i_ + 1

        MESH = DEFI_GROUP(reuse=__MAIL, MAILLAGE=__MAIL, **motscles1)
        return __Nodes, Bound, Holes




    #=========================================================================
    # Base model definition
    #=========================================================================


    mm = partition.MAIL_PY()
    mm.FromAster(__MAIL)


    __UNITE_MAILLAGE = mm.ToAster()

    # Extraction of materials
    b_mater = BETON.nom    # Names of the materials inside sd_mater
    a_mater = ACIER.nom

    __STEEL_mat = aster.getvectjev("%s" % (a_mater) + " "*(8-len(a_mater)) + ".CPT.000001.VALR        ")

    __ES = __STEEL_mat[0]

    __CONCRETE_mat = aster.getvectjev("%s" % (b_mater) + " "*(8-len(b_mater)) + ".CPT.000001.VALR        ")
    __EC = __CONCRETE_mat[0]


    # Importing the FE results and mesh
    __Nodes, __Elements, p_n_stress, __U, __V = input_results(__MAIL, __SIEQ)


    if (max(__Nodes[:, 3]) != min(__Nodes[:, 3])) and (sum(__Nodes[:, 3] < 10E-6) + sum(__Nodes[:, 3] >= 0)) > 0:
        UTMESS('F', 'CALCBT_9')


    # Nodal groups associated to the boundary conditions
    __grno = mm.gno
    __SUPPORTS, __FORCES = B_BC(__grno, __GROUP_S, __GROUP_F)    # Loads and supports


    # Geometry's "skin"
    __grma = mm.gma
    __N_Bound, __Bound, __Holes = SKIN(__grma, __Nodes, __GROUP_S.keys(), __GROUP_F.keys(), __GROUP_C)    # Geometry loops

    # Geometry's maximum dimentions and real merging tolerances
    __max_dimx = max(__Nodes[:, 1]) - min(__Nodes[:, 1])
    __max_dimy = max(__Nodes[:, 2]) - min(__Nodes[:, 2])
    __max_dim = max(__max_dimx, __max_dimy)

    TOLERANCE1 = __max_dim*__TOLE_BASE

    if TOLE_BT is None:
        TOLERANCE2 = __max_dim*__TOLE_BASE

    else:
        TOLERANCE2 = __max_dim*__TOLE_BT

    # Material properties
    __steel = ACIER
    __concre = BETON


    #=========================================================================
    # Errors in the inputs
    #=========================================================================
    if __SCHEMA == 'TOPO' and RESI_RELA_TOPO <= RESI_RELA_SECTION:
        UTMESS('F', 'CALCBT_3')

    if len(__Bound) == len(np.unique(__Bound)):
        UTMESS('F', 'CALCBT_5')

    #=========================================================================
    # Warnings in the inputs
    #=========================================================================
    if __SCHEMA == 'SECTION' and __CONVER2 != 1E-6:
        UTMESS('A', 'CALCBT_4')

    if __SCHEMA == 'SECTION' and __MELIM != 0.5:
        UTMESS('A', 'CALCBT_8')




    #=========================================================================
    # Ground structure
    #=========================================================================

    # Local peaks and valleys

    Lines_x = complex(0, 1 + __max_dimx/__PAS_ITERPOL_X)
    Lines_y = complex(0, 1 + __max_dimy/__PAS_ITERPOL_Y)

    __L_M, __P_S_I, __V_S_III = local_pnv(__Nodes, p_n_stress, Lines_x, __PAS_ITERPOL_X, Lines_y, __PAS_ITERPOL_Y,
                              __Holes)


    # Voronoi division

    regions, vertices = Geometry_div(__N_Bound[:, 1:3], __Bound, __Holes, __L_M, __Nodes, __SUPPORTS, __FORCES, TOLERANCE1)


    # Holes in the structure
    n = 0
    if len(__Holes) > 0:
        B = np.zeros((len(__V_S_III[:, 0]), len(__Holes)), dtype=bool)
        j_ = 0
        for key in __Holes.keys():
            __H_bound = __Holes[key]
            n = n + len(__H_bound) - 1
            for i_ in range(len(__V_S_III[:, 0])):

                B[i_, j_] = is_inpolygon(__V_S_III[i_,:], __Nodes[__H_bound.astype(int), 1:3], 1)

            j_ = j_ + 1

        for i_ in range(len(__Holes)):
            B[:, 0] = B[:, 0] + B[:, i_]

        A_ = B[:, 0] > 0

    else:
        A_ = np.zeros((len(__V_S_III[:, 0])), dtype=bool)


    # Initial strut path
    __N_path = ini_s_path(__Nodes, __U, __V, __SUPPORTS, __FORCES, vertices, regions, __V_S_III[A_ == False], 1, __N_Bound[:, 1:3], __Bound)


    __CORNERS = np.ones((n), dtype=int) * -1
    if len(__Holes) > 0:
        B = np.zeros((len(__P_S_I[:, 0]), len(__Holes)), dtype=bool)
        j_ = 0

        for key in __Holes.keys():
            __H_bound = __Holes[key]
            __CORNERS[sum(__CORNERS > -1):(sum(__CORNERS > -1) + len(__H_bound) - 1)] = __H_bound[0:-1]

            for i_ in range(len(__P_S_I[:, 0])):
                B[i_, j_] = is_inpolygon(__P_S_I[i_,:], __N_Bound[__H_bound.astype(int), 1:3], 1)

            j_ = j_ + 1

        for i_ in range(len(__Holes)):
            B[:, 0] = B[:, 0] + B[:, i_]

        A = B[:, 0] > 0

    else:
        A = np.zeros((len(__P_S_I[:, 0])), dtype=bool)

    __int_nodes = np.zeros((len(__SUPPORTS[:, 0])+len(__FORCES[:, 0]) + n, 4))
    __int_nodes[0:len(__SUPPORTS[:, 0]),:] = __Nodes[__SUPPORTS[:, 0] - 1,:]
    __int_nodes[len(__SUPPORTS[:, 0]):(len(__SUPPORTS[:, 0]) + len(__FORCES[:, 0])),:] = __Nodes[__FORCES[:, 0] - 1,:]
    __int_nodes[(len(__SUPPORTS[:, 0]) + len(__FORCES[:, 0]))::,:] = __Nodes[__CORNERS,:]


    __W_ = weight_(__P_S_I[A == False], __Nodes, __int_nodes)

    __P_S_I_1 = merge_nodes(__P_S_I[A == False], TOLERANCE2, __W_)

    __W_ = weight_(__N_path, __Nodes, __int_nodes)
    __N_path_1 = merge_nodes(__N_path, TOLERANCE2/2, __W_)




    __GS_nodes, __N_o_S, __Con_Mat = second_(__N_Bound, __Bound, __Nodes, __int_nodes, __FORCES,
                                             __N_path_1, __P_S_I_1, __V_S_III[A_ == False],
                                             __Holes, __MAXLON, TOLERANCE2/2, 0, __CORNERS) #1



    #=========================================================================
    # Optimisation
    #=========================================================================

    if len(__Con_Mat) == 0:
        UTMESS('F', 'CALCBT_10')

    __GS_nodes, __Con_Mat, __AREAS, __Forces, __resu, TABLE = op_global(__GS_nodes, __Con_Mat,
                                                                        __N_o_S, __MAXITER,
                                                                        __MINSEC, __UNITE_MAILLAGE,
                                                                        __SEVOL, __EC, __ES, __FC,
                                                                        __FY, __SCHEMA, __CONVER1,
                                                                        __CONVER2, __MELIM,
                                                                        __GROUP_S, __GROUP_F, INIT_ALEA,
                                                                        __GROUP_S, __GROUP_F)

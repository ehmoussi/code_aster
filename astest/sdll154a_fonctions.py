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
import numpy as np

def fsolve(func, x0):
    epsfcn = np.finfo(np.dtype(float)).eps
    eps = epsfcn**0.5
    delta_x = 1.
    x = x0
    while abs(delta_x) > 1.49012e-08:
        f_x = func(x)
        d_x = max(eps, eps*abs(x))
        df_x = (func(x+d_x) - f_x) / d_x
        delta_x = - f_x / df_x
        x += delta_x
    return x

class PostRocheAnalytic(object):
    """classe pour calcul analytique des valeurs de post roche"""
    # pression imposée
    _pression = 1.e6
    # loi ramberg osgood
    _K = 0.01
    _n = 2
    _E = 2.e11
    # Z : module d'inertie pour les poutres circulaires : Iy / R
    _Z = 7.36311E-09 / 0.01
    # B_2 = 1. pour les tronçons de partie droite
    _B_2 = 1.
    # coefficients de contraintes
    _D_21 = 0.712
    _D_22 = 0.429*(0.02/0.005)**0.16
    _D_23 = _D_22
    def __init__(self, mfy_poids_propre, mt_deplacement_impose, mfy_sismique_dyn, mfz_sismique_dyn, mfy_sismique_qs, mfz_sismique_qs):
        self._mfy_poids_propre = mfy_poids_propre
        self._mt_deplacement_impose = mt_deplacement_impose
        self._mfy_sismique_dyn = mfy_sismique_dyn
        self._mfz_sismique_dyn = mfz_sismique_dyn
        self._mfy_sismique_qs = mfy_sismique_qs
        self._mfz_sismique_qs = mfz_sismique_qs
    def _epsi_p(self, sigma):
        """epsi plastique pour Ranberg osgood"""
        return self._K*(sigma/self._E)**(1/self._n)
    def calcul_ressort(self):
        """calcule self._sigma_deplacement_ref, self._sigma_sismique_ref, self._t, self._ts, self._T, self._T_s, self._r_m et self._r_s"""
        # moments en deplacements à abattres
        mt_deplacement = np.abs(self._mt_deplacement_impose)
        mf_sismique = np.sqrt(self._mfy_sismique_dyn**2+self._mfz_sismique_dyn**2)
        # sigma ref
        self._sigma_deplacement_ref = 0.87*mt_deplacement/self._Z
        self._sigma_sismique_ref = 0.79*self._B_2*mf_sismique/self._Z
        # reversibilites locales
        sig_over_E = self._sigma_deplacement_ref/self._E
        sig_over_E = (sig_over_E > 1e-6)*sig_over_E
        self._t = sig_over_E / self._epsi_p(self._sigma_deplacement_ref)
        sig_over_E = self._sigma_sismique_ref/self._E
        sig_over_E = (sig_over_E > 1e-6)*sig_over_E
        self._t_s = sig_over_E / self._epsi_p(self._sigma_sismique_ref)
        # reversibilité totales
        self._T = sum(self._sigma_deplacement_ref[self._t!=0]**2) / sum(self._sigma_deplacement_ref[self._t!=0]**2/self._t[self._t!=0])
        self._T_s = sum(self._sigma_sismique_ref[self._t_s!=0]**2) / sum(self._sigma_sismique_ref[self._t_s!=0]**2/self._t_s[self._t_s!=0])
        # ressorts
        self._r_m = np.maximum(np.array([self._T/t-1 if t!=0. else 0. for t in self._t]), np.zeros([4]))
        self._r_s = np.maximum(np.array([self._T_s/t-1 if t!=0. else 0. for t in self._t_s]), np.zeros([4]))
        return self._r_m, self._r_s
    def calcul_abattement(self):
        """calcule self._sigma_deplacement, self._sigma_sismique, self._g, self._g_s"""
        def func(x):
            """equation de contrainte vrai"""
            return (x/self._E + self._epsi_p(x) - self._epsi_p(sigma_ref)) + r * (x-sigma_ref) / self._E
        # resolution sigma_deplacement
        sigma_deplacement = []
        for sigma_ref, r in zip(self._sigma_deplacement_ref, self._r_m):
            root = fsolve(func, sigma_ref)
            sigma_deplacement.append(root)
        self._sigma_deplacement = np.array(sigma_deplacement)
        # resolution sigma_sismique
        sigma_sismique = []
        for sigma_ref, r in zip(self._sigma_sismique_ref, self._r_s):
            root = fsolve(func, sigma_ref)
            sigma_sismique.append(root)
        self._sigma_sismique = np.array(sigma_sismique)
        # abbatements
        self._g = (self._sigma_deplacement-self._pression) / (self._sigma_deplacement_ref-self._pression)
        self._g_s = (self._sigma_sismique-self._pression) / (self._sigma_sismique_ref-self._pression)
        return self._g, self._g_s
    def calcul_sigma_eq(self):
        """calcule le sigma equivalent"""
        self._sigma_eq = 1/self._Z * (self._D_21**2*(self._g*self._mt_deplacement_impose)**2 + \
                      self._D_22**2*(abs(self._mfy_poids_propre)+abs(self._mfy_sismique_qs)+self._g_s*abs(self._mfy_sismique_dyn))**2 \
                + self._D_23**2*(abs(self._mfz_sismique_qs)+self._g_s*abs(self._mfz_sismique_dyn))**2  )**0.5
        return self._sigma_eq

import numpy as np
from scipy.optimize import fsolve

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
    def __init__(self, mfy_poids_propre, mt_deplacement_impose, mfy_sismique_dyn, mfz_sismique_dyn, mfy_sismique_qs, mfz_sismique_qs,\
                        mfy_dilatation_thermique, mt_sismique_dyn, mt_sismique_qs):
        self._mfy_poids_propre = mfy_poids_propre
        self._mt_deplacement_impose = mt_deplacement_impose
        self._mfy_sismique_dyn = mfy_sismique_dyn
        self._mfz_sismique_dyn = mfz_sismique_dyn
        self._mfy_sismique_qs = mfy_sismique_qs
        self._mfz_sismique_qs = mfz_sismique_qs
        
        self._mfy_dilatation_thermique = mfy_dilatation_thermique
        self._mt_sismique_dyn = mt_sismique_dyn
        self._mt_sismique_qs = mt_sismique_qs
    def _epsi_p(self, sigma):
        """epsi plastique pour Ranberg osgood"""
        return self._K*(sigma/self._E)**(1/self._n)
    def calcul_ressort(self):
        """calcule self._sigma_deplacement_ref, self._sigma_sismique_ref, self._t, self._ts, self._T, self._T_s, self._r_m et self._r_s"""
        # moments en deplacements à abattres
        mt_deplacement = np.abs(self._mt_deplacement_impose)
        mf_delpacement = np.abs(self._mfy_dilatation_thermique)
        mf_sismique = np.sqrt(self._mfy_sismique_dyn**2+self._mfz_sismique_dyn**2)
        # sigma ref
        self._sigma_deplacement_ref = ((0.87*mt_deplacement/self._Z)**2 + (0.79*self._B_2*mf_delpacement/self._Z)**2)**0.5
        self._sigma_sismique_ref = ((0.87*self._mt_sismique_dyn/self._Z)**2 + (0.79*self._B_2*mf_sismique/self._Z)**2)**0.5
        # reversibilites locales
        sig_over_E = self._sigma_deplacement_ref/self._E
        sig_over_E = (sig_over_E > 1e-6)*sig_over_E
        self._t = sig_over_E / self._epsi_p(self._sigma_deplacement_ref)
        sig_over_E = self._sigma_sismique_ref/self._E
        sig_over_E = (sig_over_E > 1e-6)*sig_over_E
        self._t_s = sig_over_E / self._epsi_p(self._sigma_sismique_ref)
        self._t_s = sig_over_E / self._epsi_p(self._sigma_sismique_ref)
        # reversibilité totales
        T_1 = sum(self._sigma_deplacement_ref[:4][self._t[:4]!=0]**2) / sum(self._sigma_deplacement_ref[:4][self._t[:4]!=0]**2/self._t[:4][self._t[:4]!=0])
        T_2 = sum(self._sigma_deplacement_ref[4:][self._t[4:]!=0]**2) / max(sum(self._sigma_deplacement_ref[4:][self._t[4:]!=0]**2/self._t[4:][self._t[4:]!=0]), 1.e-6)
        T_s_1 = sum(self._sigma_sismique_ref[:4][self._t_s[:4]!=0]**2) / sum(self._sigma_sismique_ref[:4][self._t_s[:4]!=0]**2/self._t_s[:4][self._t_s[:4]!=0])
        T_s_2 = sum(self._sigma_sismique_ref[4:][self._t_s[4:]!=0]**2) / max(sum(self._sigma_sismique_ref[4:][self._t_s[4:]!=0]**2/self._t_s[4:][self._t_s[4:]!=0]), 1.e-6)
        self._T = np.array([T_1]*4+[T_2]*2)
        self._T_s = np.array([T_s_1]*4+[T_s_2]*2)
        # ressorts
        self._r_m = np.maximum(np.array([T/t-1 if t!=0. else 0. for t, T in zip(self._t, self._T)]), np.zeros([6]))
        self._r_s = np.maximum(np.array([T/t-1 if t!=0. else 0. for t, T in zip(self._t_s, self._T_s)]), np.zeros([6]))
        return self._r_m, self._r_s
    def calcul_abattement(self):
        """calcule self._sigma_deplacement, self._sigma_sismique, self._g, self._g_s"""
        def func(x):
            """equation de contrainte vrai"""
            return [(x[0]/self._E + self._epsi_p(x[0]) - self._epsi_p(sigma_ref)) + r * (x[0]-sigma_ref) / self._E]
        # resolution sigma_deplacement
        sigma_deplacement = []
        for sigma_ref, r in zip(self._sigma_deplacement_ref, self._r_m):
            root = fsolve(func, [sigma_ref])
            sigma_deplacement.append(root[0])
        self._sigma_deplacement = np.array(sigma_deplacement)
        # resolution sigma_sismique
        sigma_sismique = []
        for sigma_ref, r in zip(self._sigma_sismique_ref, self._r_s):
            root = fsolve(func, [sigma_ref])
            sigma_sismique.append(root[0])
        self._sigma_sismique = np.array(sigma_sismique)
        # abbatements
        self._g = (self._sigma_deplacement-self._pression) / (self._sigma_deplacement_ref-self._pression)
        self._g_s = (self._sigma_sismique-self._pression) / (self._sigma_sismique_ref-self._pression)
        return self._g, self._g_s
    def calcul_sigma_eq(self):
        """calcule le sigma equivalent"""
        self._sigma_eq = 1/self._Z * (self._D_21**2*(abs(self._mt_sismique_qs)+self._g*abs(self._mt_deplacement_impose)+self._g_s*abs(self._mt_sismique_dyn))**2 + \
                      self._D_22**2*(abs(self._mfy_poids_propre)+abs(self._mfy_sismique_qs)+self._g*abs(self._mfy_dilatation_thermique)+self._g_s*abs(self._mfy_sismique_dyn))**2 + \
                        self._D_23**2*(abs(self._mfz_sismique_qs)+self._g_s*abs(self._mfz_sismique_dyn))**2  )**0.5
        return self._sigma_eq

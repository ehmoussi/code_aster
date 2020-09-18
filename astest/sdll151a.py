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

from numpy import array, pi, sqrt, interp

eps = 1.e-6  # convergence precision for the eigenfrequencies

########################################################
# INPUT DATA

L = 0.15    # m  (beam length)
l = 0.01    # m  (beam width)

# elastic part (classical elastic material)
E1 = 2.1e11     # Pa   (Young modulus)
H1 = 1.e-3      # m    (layer thickness)
eta1 = 0.001    #      (hysteretic damping)
rho1 = 7800.    # kg/m3  (volumic mass)
E1c = E1 * complex(1.,eta1)

# viscoelastic part of the beam
H2 = 2.e-3      # m     (layer thickness)
rho2 = 1200.    # kg/m3 (volumic mass)
# properties depending on the frequency (given at the frequencies fp)
fv = array([1., 10., 50., 100., 500., 1000., 1500.]) # Hz
Ev = array([23.2, 58., 145., 203., 348., 435., 464.])*1.e6 # Pa   (Young modulus(real part))
etav = array([1.1, 0.85, 0.7, 0.6, 0.4, 0.35, 0.34]) #      (damping factor)

# special data
lambda_f = [1.87510407, 4.69409113, 7.85475744, 10.99554073] # eigenfrequency factor


########################################################


eigenfreq = [None] * len(lambda_f)
eigendamp = [None] * len(lambda_f)


########################################################
# ITERATIVE - ANALYTICAL COMPUTING OF THE SOLUTION

for i in range(0, len(lambda_f)):

    betal = lambda_f[i]

    fc = 0.1
    if i==0:
        fc_new = 10.

    while (fc_new-fc)/fc > eps:

        fc= fc_new

        # interpolation For the properties depending on the frequency
        E2   = interp( fc, fv, Ev )
        eta2 = interp( fc, fv, etav )

        # conversion
        E2c = E2 * complex(1.,eta2)

        # intermediate variables
        e2 = E2c/E1c
        h2 = H2/H1
        I1 = l*H1**3. / 12.
        rhoA = (rho1*H1+rho2*H2)*l

        # dynamic stiffness
        EI = E1*I1* (1.+e2*h2**3.+3.*(1+h2)**2.*(e2*h2)/(1.+e2*h2))

        # results: eigenfrequency and damping estimates
        fc_new  = 1. / (2.*pi)*betal**2.*(EI.real/(rhoA*L**4.))**0.5
        eta_new = EI.imag / EI.real

    eigenfreq[i] = fc_new
    eigendamp[i] = eta_new / 2.

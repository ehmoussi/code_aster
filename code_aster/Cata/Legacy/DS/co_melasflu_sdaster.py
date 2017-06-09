# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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


import aster
from code_aster.Cata.Syntax import ASSD, AsException


class melasflu_sdaster(ASSD):
    cata_sdj = "SD.sd_melasflu.sd_melasflu"


    def VITE_FLUI (self):
        """
        Returns a python list of fluid velocities under which modal paramteres have been
        successfully calculated under the defined fluid-elastic conditions"""

        if not self.accessible():
            # Method is not allowed for For PAR_LOT = 'OUI' calculations
            raise AsException("Erreur dans melas_flu.VITE_FLUIDE() en PAR_LOT='OUI'")

        vite = self.sdj.VITE.get()
        freq_obj = self.sdj.FREQ.get()

        nbv = len(vite)
        nbm = len(freq_obj)/(2*nbv)
        vite_ok = []
        for iv in range(nbv):
            freqs   = [freq_obj[2*nbm*(iv)+2*(im)] for im in range(nbm)] # Extract a list of all modes for a given fluid velocity no. iv
            calc_ok = ([freq>0 for freq in freqs].count(False)==0)       # Check that all frequencies are positive for this velocity
            if calc_ok : vite_ok.append(vite[iv])

        return vite_ok

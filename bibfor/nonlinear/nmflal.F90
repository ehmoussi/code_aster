! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmflal(option, ds_posttimestep, mod45 , l_hpp ,&
                  nfreq , cdsp           , typmat, optmod, bande ,&
                  nddle , nsta           , modrig)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=16) :: optmod, option
character(len=4) :: mod45
integer :: nfreq, nddle, nsta, cdsp
character(len=16) :: typmat, modrig
real(kind=8) :: bande(2)
type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
aster_logical, intent(out) :: l_hpp
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL DE MODES)
!
! LECTURE DES OPTIONS DANS MECA_NON_LINE
!
! --------------------------------------------------------------------------------------------------
!
! IN  OPTION : TYPE DE CALCUL
!              'FLAMBSTA' MODES DE FLAMBEMENT EN STATIQUE
!              'FLAMBDYN' MODES DE FLAMBEMENT EN DYNAMIQUE
!              'VIBRDYNA' MODES VIBRATOIRES
! In  ds_posttimestep  : datastructure for post-treatment at each time step
! OUT MOD45  : TYPE DE CALCUL DE MODES PROPRES
!              'VIBR'     MODES VIBRATOIRES
!              'FLAM'     MODES DE FLAMBEMENT
!              'STAB'     MODE DE STABILITE
! OUT NFREQ  : NOMBRE DE FREQUENCES A CALCULER
! OUT CDSP   : COEFFICIENT MULTIPLICATEUR DE NFREQ -> DIM_SPACE
! OUT TYPMAT : TYPE DE MATRICE A UTILISER
!                'ELASTIQUE/TANGENTE/SECANTE'
! OUT OPTMOD : OPTION DE RECHERCHE DE MODES
!               'PLUS_PETITE' LA PLUS PETITE FREQUENCE
!               'BANDE'       DANS UNE BANDE DE FREQUENCE DONNEE
! OUT l_hpp   : TYPE DE DEFORMATIONS
!                0            PETITES DEFORMATIONS (MATR. GEOM.)
!                1            GRANDES DEFORMATIONS (PAS DE MATR. GEOM.)
! OUT BANDE  : BANDE DE FREQUENCE SI OPTMOD='BANDE'
! OUT NDDLE  : NOMBRE DE DDL EXCLUS
! OUT DDLEXC : NOM DE L'OBJET JEVEUX CONTENANT LE NOM DES DDLS EXCLUS
! OUT NSTA   : NOMBRE DE DDL STAB
! OUT DDLSTA : NOM DE L'OBJET JEVEUX CONTENANT LE NOM DES DDLS STAB
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: optrig
!
! --------------------------------------------------------------------------------------------------
!
    bande(1) = 1.d-5
    bande(2) = 1.d5
    nfreq = 0
    cdsp = 0
    nddle = 0
    mod45 = ' '
    optmod = ' '
    optrig = ' '
    typmat = ' '
    nsta = 0
    l_hpp  = ASTER_TRUE
!
! --- RECUPERATION DES OPTIONS
!
    if (option(1:7) .eq. 'VIBRDYN') then
        nfreq  = ds_posttimestep%mode_vibr%nb_eigen
        cdsp   = ds_posttimestep%mode_vibr%coef_dim_espace
        typmat = ds_posttimestep%mode_vibr%type_matr_rigi
        if (ds_posttimestep%mode_vibr%l_small) then
            optmod = 'PLUS_PETITE'
        else
            optmod = 'BANDE'
        endif
        bande  = ds_posttimestep%mode_vibr%strip_bounds
        mod45  = 'VIBR'
        
    else if (option(1:5) .eq. 'FLAMB') then
        nfreq  = ds_posttimestep%crit_stab%nb_eigen
        cdsp   = ds_posttimestep%crit_stab%coef_dim_espace
        typmat = ds_posttimestep%crit_stab%type_matr_rigi
        if (ds_posttimestep%crit_stab%l_small) then
            optmod = 'PLUS_PETITE'
        else
            optmod = 'BANDE'
        endif
        bande  = ds_posttimestep%crit_stab%strip_bounds
        mod45 = 'FLAM'
        nddle  = ds_posttimestep%stab_para%nb_dof_excl
        nsta   = ds_posttimestep%stab_para%nb_dof_stab
        if (ds_posttimestep%stab_para%l_modi_rigi) then
            modrig = 'MODI_RIGI_OUI'
        endif
        l_hpp  = ds_posttimestep%l_hpp
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine

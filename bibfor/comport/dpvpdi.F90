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

subroutine dpvpdi(nbmat, mater, td, tf, tr,&
                  depst, deps)
! --- LOI DE COMPORTEMENT DE TYPE DRUCKER PRAGER VISCOPLASTIQUE -
! --- VISC_DRUC_PRAG
! --- RETRAIT DE LA DEFORMATION DUE A LA DILATATION THERMIQUE ---------
! =====================================================================
    implicit none
#include "asterfort/utmess.h"
    integer :: nbmat
    real(kind=8) :: mater(nbmat, 2), td, tf, tr, depst(6), deps(6)
! =====================================================================
! --- IN --- : NBMAT   NOMBRE DE PARAMETRES DU MODELE -----------------
! --- IN --- : MATER   COEFFICIENTS MATERIAU --------------------------
! ---------- : TD      TEMPERATURE DEBUT INCREMENT --------------------
! ---------- : TF      TEMPERATURE FIN INCREMENT ----------------------
! ---------- : TR      TEMPERATURE DE REFERENCE -----------------------
! ---------- : DEPST   INCREMENT DE DEFORMATION TOTALE ----------------
! --- OUT -- : DEPS   INCREMENT DE DEFORMATION MECANIQUE -------------
! =====================================================================
    integer :: ii, ndt, ndi
    real(kind=8) :: alpha
! =====================================================================
    common /tdim/   ndt, ndi
! =====================================================================
! --- LES PARAMETRES MATERIAUX SONT SUPPOSES CONSTANT -----------------
! =====================================================================
!
    alpha = mater(3,1)
! INITIALISATION DE DEPS A DEPST
!
    do 5 ii = 1, ndt
        deps(ii) = depst(ii)
 5  continue
!
!
    if ((.not.isnan(tr)) .and. (.not.isnan(tf)) .and. (.not.isnan(td))) then
        do 10 ii = 1, ndi
            deps(ii) = depst(ii) - ( alpha*(tf-tr) - alpha*(td-tr))
10      continue
        do 20 ii = ndi+1, ndt
            deps(ii) = depst(ii)
20      continue
        elseif (((.not.isnan(tr)).or.(.not.isnan(td)).or. (.not.isnan(tf))) &
                  .and.(alpha.ne.0.d0)) then
        call utmess('F', 'CALCULEL_15')
    endif
! =====================================================================
end subroutine

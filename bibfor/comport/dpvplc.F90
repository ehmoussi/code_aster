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

subroutine dpvplc(typmod, option, imate, carcri, instam,&
                  instap, depsm,&
                  sigm, vim, sig, vip, dsidep,&
                  iret)
!
implicit none
!
#include "asterfort/dpvpdi.h"
#include "asterfort/dpvpma.h"
#include "asterfort/dpvpre.h"
#include "asterfort/get_varc.h"
!
!
    integer :: imate, iret
    real(kind=8) :: depsm(6), vim(*), vip(*), sig(6), dsidep(6, 6)
    real(kind=8) :: sigm(6)
    real(kind=8) :: instam, instap, carcri(*)
    character(len=8) :: typmod(*)
    character(len=16) :: option
! =====================================================================
! --- LOI DE COMPORTEMENT DE TYPE DRUCKER PRAGER VISCOPLASTIQUE -
! --- VISC_DRUC_PRAG --------------------------------------------------
! --- ECROUISSAGE LINEAIRE --------------------------------------------
! ----VISCOSITE DE TYPE PERZYNA ---------------------------------------
! =====================================================================
! IN  DEPSM    INCREMENT DU CHAMP DE DEFORMATION
! IN  SIGM     CONTRAINTES EN T-
! IN  VIM     VARIABLES INTERNES EN T-
!               1   : P
!               2   : INDICATEUR DE PLASTICITE
!               3   : POSITION DE PAR RAPPORT A PPIC et à PULT
!               4   : NOMBRE D ITERATIONS POUR LA CONVERGENCE LOCALE
! OUT SIG    CONTRAINTES EN T+
! VAR VIP     VARIABLES INTERNES EN T+
! OUT DSIDEP  MATRICE TANGENTE
! OUT IRET    CODE RETOUR (0 = OK)
! =====================================================================
    integer :: nbmat, ndt, ndi, nvi, indal, nbre
    parameter    (nbmat  = 50 )
    real(kind=8) :: materd(nbmat, 2), materf(nbmat, 2), deps(6)
    real(kind=8) :: td, tf, tr
    character(len=3) :: matcst
! =====================================================================
    common /tdim/   ndt, ndi
! =====================================================================
    matcst = 'OUI'
!
! - Get temperatures
!
    call get_varc('RIGI' , 1  , 1 , 'T',&
                  td, tf, tr)
! =====================================================================
! --- RECUPERATION DU TYPE DE LOI DE COMPORTEMENT DP ------------------
! =====================================================================
    call dpvpma(typmod(1), imate, nbmat, td, materd,&
                materf, matcst, ndt, ndi, nvi,&
                indal)
! =====================================================================
! --- RETRAIT DE LA DEFORMATION DUE A LA DILATATION THERMIQUE ---------
! =====================================================================
    call dpvpdi(nbmat, materf, td, tf, tr,&
                depsm, deps)
!
! =====================================================================
! --- RESOLTUTION DE LA LOI DRUCKER PRAGER VISCOPLASTIQUE -------------
! =====================================================================
    call dpvpre(typmod(1), nvi, option, carcri, instam,&
                instap, nbmat, materf, sigm, deps,&
                vim, vip, sig, nbre, dsidep,&
                iret)
! =====================================================================
end subroutine

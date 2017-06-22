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

subroutine vrcpto(compor, deps, neps, fami, kpg,&
                  ksp, imate)
!
!
    implicit none
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    integer :: imate, kpg, ksp
    character(len=*) :: fami
    character(len=16) :: compor(*)
    integer :: neps
    real(kind=8) :: deps(neps)
! ----------------------------------------------------------------------
!     ON CALCULE LA DEFORMATION MECANIQUE ASSOCIEE A LA VARIABLE DE
!     COMMANDE PTOT.
!     ON LA RETRANCHE ENSUITE AUX DEFORMATIONS MECANIQUES TOTALES DEPS
!
!
! IN COMPOR   : COMPORTEMENT DE L ELEMENT
!                COMPOR(1) = RELATION DE COMPORTEMENT (VMIS_...)
!                COMPOR(2) = NB DE VARIABLES INTERNES
!                COMPOR(3) = TYPE DE DEFORMATION (PETIT,GREEN...)
! IN/OUT DEPS : INCREMENT DE DEFORMATION
! IN  NEPS    : NOMBRE DE CMP DE DEPS (SUIVANT MODELISATION)
! IN  FAMI    : FAMILLE DE POINTS DE GAUSS
! IN  KPG,KSP : NUMERO DU (SOUS)POINT DE GAUSS
! IN  IMATE   : ADRESSE DU MATERIAU CODE
!
    integer :: icodre(2)
    character(len=16) :: nomres(2)
    real(kind=8) :: valres(2)
    real(kind=8) :: ptotm, ptotp, biotp, biotm, em, num, ep, nup, troikp, troikm
    integer :: iret1, iret2, k
!
    aster_logical :: lpomec
    integer :: dmmeca, ii
    parameter     ( dmmeca = 21 )
    character(len=16) :: pomeca(dmmeca)
!
    data pomeca / 'ELAS'            ,&
     &              'CJS'             ,&
     &              'HUJEUX'          ,&
     &              'MOHR_COULOMB'    ,&
     &              'CAM_CLAY'        ,&
     &              'BARCELONE'       ,&
     &              'LAIGLE'          ,&
     &              'LETK'            ,&
     &              'LKR'             ,&
     &              'VISC_DRUC_PRAG'  ,&
     &              'HOEK_BROWN_EFF'  ,&
     &              'HOEK_BROWN_TOT'  ,&
     &              'MAZARS'          ,&
     &              'ENDO_ISOT_BETON' ,&
     &              'ELAS_GONF'       ,&
     &              'DRUCK_PRAGER'    ,&
     &              'DRUCK_PRAG_N_A'  ,&
     &              'JOINT_BANDIS'    ,&
     &              'CZM_LIN_REG'     ,&
     &              'CZM_EXP_REG'     ,&
     &              'ENDO_HETEROGENE' /
!
!
! DEB ------------------------------------------------------------------
!
    call rcvarc(' ', 'PTOT', '-', fami, kpg,&
                ksp, ptotm, iret1)
    call rcvarc(' ', 'PTOT', '+', fami, kpg,&
                ksp, ptotp, iret2)
!
    if ((iret1.eq.1) .and. (iret2.eq.1)) goto 9999
!
    if (iret1 .ne. iret2) then
        call utmess('F', 'CHAINAGE_11')
    endif
!
    if ((iret1.eq.0) .and. (iret2.eq.0)) then
!
        lpomec = .false.
        do 1 ii = 1, dmmeca
            if (compor(1) .eq. pomeca(ii)) lpomec = .true.
  1     continue
!
        if (.not.lpomec) then
            call utmess('F', 'CHAINAGE_9', sk=compor(1))
        endif
!
        if (compor(3) .ne. 'PETIT') then
            call utmess('F', 'CHAINAGE_8')
        endif
!
!
! --- COEFFICIENT DE BIOT
!
        nomres(1)='BIOT_COEF'
!
        call rcvalb(fami, kpg, ksp, '-', imate,&
                    ' ', 'THM_DIFFU', 0, ' ', [0.d0],&
                    1, nomres(1), valres(1), icodre, 1)
        if (icodre(1) .ne. 0) valres(1) = 0.d0
        biotm = valres(1)
!
        call rcvalb(fami, kpg, ksp, '+', imate,&
                    ' ', 'THM_DIFFU', 0, ' ', [0.d0],&
                    1, nomres(1), valres(1), icodre, 1)
        if (icodre(1) .ne. 0) valres(1) = 0.d0
        biotp = valres(1)
!
! --- MODULE DE YOUNG ET COEFFICIENT DE POISSON
!
        nomres(1)='E'
        nomres(2)='NU'
!
        call rcvalb(fami, kpg, ksp, '-', imate,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 2)
        if (icodre(1) .ne. 0) valres(1) = 0.d0
        if (icodre(2) .ne. 0) valres(2) = 0.d0
        em = valres(1)
        num = valres(2)
!
        call rcvalb(fami, kpg, ksp, '+', imate,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    2, nomres, valres, icodre, 2)
        if (icodre(1) .ne. 0) valres(1) = 0.d0
        if (icodre(2) .ne. 0) valres(2) = 0.d0
        ep = valres(1)
        nup = valres(2)
!
        troikp = ep/(1.d0-2.d0*nup)
        troikm = em/(1.d0-2.d0*num)
!
! --- CALCUL DE LA DEFORMATION TOTALE ACTUALISEE
!
        do 10 k = 1, 3
            deps(k) = deps(k)-(biotp/troikp*ptotp-biotm/troikm*ptotm)
 10     continue
!
    endif
!
9999 continue
!
end subroutine

! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine te0201(option, nomte)
!
use Behaviour_module, only : behaviourOption
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmfi2d.h"
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "asterfort/Behaviour_type.h"
#include "blas/dcopy.h"

!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: PLAN_JOINT
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kk, i, j, npg
    integer :: igeom, imater, icarcr, icomp, idepm, iddep, icoret
    integer :: icontm, icontp, ivect, imatr
    integer :: ivarim, ivarip, jtab(7), iret, iinstm, iinstp
    integer :: lgpg, codret
    real(kind=8) :: mat(8, 8), fint(8), sigmo(6, 2), sigma(6, 2)
    character(len=8) :: typmod(2)
    character(len=16) :: rela_comp
    aster_logical :: matsym
    aster_logical :: lVect, lMatr, lVari, lSigm
!
! --------------------------------------------------------------------------------------------------
!
    npg=2
    ivarip=1
    icoret=1
    icontp=1
    ivect=1
    icoret=1
!
! - Type of finite element
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else
        typmod(1) = 'PLAN'
    endif
    typmod(2) = 'ELEMJOIN'
!
! - Get input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imater)
    call jevech('PCARCRI', 'L', icarcr)
    call jevech('PCOMPOR', 'L', icomp)
    call jevech('PDEPLMR', 'L', idepm)
    call jevech('PDEPLPR', 'L', iddep)
    call jevech('PVARIMR', 'L', ivarim)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PINSTMR', 'L', iinstm)
    call jevech('PINSTPR', 'L', iinstp)
    call tecach('OOO', 'PVARIMR', 'L', iret, nval=7, itab=jtab)
    lgpg = max(jtab(6),1)*jtab(7)
!
! - Select objects to construct from option name
!
    call behaviourOption(option, zk16(icomp),&
                         lMatr , lVect ,&
                         lVari , lSigm ,&
                         codret)
!
! - Properties of behaviour
!
    rela_comp = zk16(icomp-1+RELA_NAME)
!
! - Get output fields
!
    if (lMatr) then
        matsym = .true.
        if (rela_comp .eq. 'JOINT_MECA_RUPT') matsym = .false.
        if (rela_comp .eq. 'JOINT_MECA_FROT') matsym = .false.
    endif
    if (lVari) then
        call jevech('PVARIPR', 'E', ivarip)
    endif
    if (lSigm) then
        call jevech('PCONTPR', 'E', icontp)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivect)
    endif

!     CONTRAINTE -, RANGEE DANS UN TABLEAU (6,NPG)
    sigmo = 0.d0
    sigmo(1,1) = zr(icontm)
    sigmo(2,1) = zr(icontm+1)
    sigmo(1,2) = zr(icontm+2)
    sigmo(2,2) = zr(icontm+3)
!
! CALCUL DES CONTRAINTES, VIP, FORCES INTERNES ET MATR TANG ELEMENTAIRES
    call nmfi2d(npg, lgpg, zi(imater), option, zr(igeom),&
                zr(idepm), zr(iddep), sigmo, sigma, fint,&
                mat, zr(ivarim), zr(ivarip), zr(iinstm), zr(iinstp),&
                zr(icarcr), zk16(icomp), typmod, lMatr, lVect, lSigm,&
                codret)
!
! - Save matrix
!
    if (lMatr) then
        if (matsym) then
            call jevech('PMATUUR', 'E', imatr)
            kk = 0
            do i = 1, 8
                do j = 1, i
                    zr(imatr+kk) = mat(i,j)
                    kk = kk+1
                end do
            end do
        else
            call jevech('PMATUNS', 'E', imatr)
            kk = 0
            do i = 1, 8
                do j = 1, 8
                    zr(imatr+kk) = mat(i,j)
                    kk = kk+1
                end do
            end do
        endif
    endif
!
! - Save stresses
!
    if (lSigm) then
        zr(icontp) = sigma(1,1)
        zr(icontp+1) = sigma(2,1)
        zr(icontp+2) = sigma(1,2)
        zr(icontp+3) = sigma(2,2)
    endif
!
! - Save internal forces
!
    if (lVect) then
        call dcopy(8, fint, 1, zr(ivect), 1)
    endif
!
! - Save return code
!
    if (lSigm) then
        call jevech('PCODRET', 'E', icoret)
        zi(icoret) = codret
    endif
!
end subroutine

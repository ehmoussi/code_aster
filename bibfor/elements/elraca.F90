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
subroutine elraca(elrefz, ndim, nno, nnos, nbfpg,&
                  fapg, nbpg, x, vol)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/elrfno.h"
!
integer, parameter            :: nbfamx = 20
character(len=*), intent(in)  :: elrefz
integer, intent(out)          :: ndim, nno, nnos, nbfpg, nbpg(nbfamx)
real(kind=8), intent(out)     :: x(*), vol
character(len=8), intent(out) :: fapg(*)
!
! --------------------------------------------------------------------------------------------------
!
! Finite elements management
!
! Get parameters of geometric support for finite element
!
! --------------------------------------------------------------------------------------------------
!
! In  elrefa           : name of geometric support for finite element
! Out ndim             : topological dimension (0/1/2/3)
! Out nno              : number of nodes
! Out nnos             : number of middle nodes
! Out nbfpg            : number of families of integration schemes
! Out fapg             : name of families of integration schemes
! Out nbpg             : number of nodes of integration schemes
! Out x                : coordinates of nodes
! Out vol              : volume of element
!
!        NBPGMX : NOMBRE DE POINTS DE GAUSS MAX DE L'ELEMENT
!                 NBPGMX=1000 DU A XFEM
!        NBNOMX : NOMBRE DE NOEUDS MAX DE L'ELEMENT
!        NBFAMX : NOMBRE DE FAMILLES DE POINTS DE GAUSS MAX DE L'ELEMENT
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefa
    integer :: i, deca
    real(kind=8) :: coorno(3,27)
!
! --------------------------------------------------------------------------------------------------
!
    elrefa = elrefz
    nbpg(1:nbfamx) = 0
!
    call elrfno(elrefa, nno, nnos, ndim, coorno)
!
    if (elrefa .eq. 'HE8') then
        vol = 8.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 8, 27, 16, 64]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG8'
        fapg(5) = 'FPG27'
        fapg(6) = 'FPG8NOS'
        fapg(7) = 'FPG64'
!
    else if (elrefa.eq.'H20') then
        vol = 8.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 8, 27, 16, 64]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG8'
        fapg(5) = 'FPG27'
        fapg(6) = 'FPG8NOS'
        fapg(7) = 'FPG64'
!
    else if (elrefa.eq.'H27') then
        vol = 8.d0
!
        nbfpg = 6
        nbpg(1:nbfpg) = [nno, nnos, 1, 8, 27, 64]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG8'
        fapg(5) = 'FPG27'
        fapg(6) = 'FPG64'
!
    else if (elrefa.eq.'TE4') then
        vol = 1.d0/6.d0
!
        nbfpg = 9
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 5, 11, 15, 23, 8]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG5'
        fapg(6) = 'FPG11'
        fapg(7) = 'FPG15'
        fapg(8) = 'FPG23'
        fapg(9) = 'FPG4NOS'
!
    else if (elrefa.eq.'TE9') then
        vol = 1.d0/6.d0
!
        nbfpg = 9
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 5, 11, 15, 23, 8]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG5'
        fapg(6) = 'FPG11'
        fapg(7) = 'FPG15'
        fapg(8) = 'FPG23'
        fapg(9) = 'FPG4NOS'
!
    else if (elrefa.eq.'T10') then
        vol = 1.d0/6.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 5, 15, 8]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG5'
        fapg(6) = 'FPG15'
        fapg(7) = 'FPG4NOS'
!
    else if (elrefa.eq.'PE6') then
        vol = 1.d0
!
        nbfpg = 8
        nbpg(1:nbfpg) = [nno, nnos, 1, 6, 6, 8, 21, 12]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG6'
        fapg(5) = 'FPG6B'
        fapg(6) = 'FPG8'
        fapg(7) = 'FPG21'
        fapg(8) = 'FPG6NOS'
!
    else if (elrefa.eq.'P13') then
        vol = 2.d0/3.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 5, 6, 27, 10]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG5'
        fapg(5) = 'FPG6'
        fapg(6) = 'FPG27'
        fapg(7) = 'FPG5NOS'
!
    else if (elrefa.eq.'P15') then
        vol = 1.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 6, 8, 21, 12]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG6'
        fapg(5) = 'FPG8'
        fapg(6) = 'FPG21'
        fapg(7) = 'FPG6NOS'
!
    else if (elrefa.eq.'P18') then
        vol = 1.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 6, 8, 21, 12]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG6'
        fapg(5) = 'FPG8'
        fapg(6) = 'FPG21'
        fapg(7) = 'FPG6NOS'
!
    else if (elrefa.eq.'PY5') then
        vol = 2.d0/3.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 5, 6, 27, 10]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG5'
        fapg(5) = 'FPG6'
        fapg(6) = 'FPG27'
        fapg(7) = 'FPG5NOS'
!
    else if (elrefa.eq.'TR3') then
        vol = 1.d0/2.d0
!
        nbfpg = 13
        nbpg(1:nbfpg) = [nno, nnos, 1, 3, 4, 6, 7, 12, 3, 6, 13, 16, 6]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG3'
        fapg(5) = 'FPG4'
        fapg(6) = 'FPG6'
        fapg(7) = 'FPG7'
        fapg(8) = 'FPG12'
        fapg(9) = 'COT3'
        fapg(10) = 'FPG3NOS'
        fapg(11) = 'FPG13'
        fapg(12) = 'FPG16'
        fapg(13) = 'SIMP'
!
    else if (elrefa.eq.'TR4') then
        vol = 1.d0/2.d0
!
        nbfpg = 13
        nbpg(1:nbfpg) = [nno, nnos, 1, 3, 4, 6, 7, 12, 3, 6, 13, 16, 6]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG3'
        fapg(5) = 'FPG4'
        fapg(6) = 'FPG6'
        fapg(7) = 'FPG7'
        fapg(8) = 'FPG12'
        fapg(9) = 'COT3'
        fapg(10) = 'FPG3NOS'
        fapg(11) = 'FPG13'
        fapg(12) = 'FPG16'
        fapg(13) = 'SIMP'
!
    else if (elrefa.eq.'TR6') then
        vol = 1.d0/2.d0
!
        nbfpg = 11
        nbpg(1:nbfpg) = [nno, nnos, 1, 3, 4, 6, 7, 12, 6, 13, 16]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG3'
        fapg(5) = 'FPG4'
        fapg(6) = 'FPG6'
        fapg(7) = 'FPG7'
        fapg(8) = 'FPG12'
        fapg(9) = 'FPG3NOS'
        fapg(10) = 'FPG13'
        fapg(11) = 'FPG16'
!
    else if (elrefa.eq.'TR7') then
        vol = 1.d0/2.d0
!
        nbfpg = 10
        nbpg(1:nbfpg) = [nno, nnos, 1, 3, 4, 6, 7, 12, 13, 16]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG3'
        fapg(5) = 'FPG4'
        fapg(6) = 'FPG6'
        fapg(7) = 'FPG7'
        fapg(8) = 'FPG12'
        fapg(9) = 'FPG13'
        fapg(10) = 'FPG16'
!
    else if (elrefa.eq.'QU4') then
        vol = 4.d0
!
        nbfpg = 8
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 9, 16, 2, 8]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG9'
        fapg(6) = 'FPG16'
        fapg(7) = 'FIS2'
        fapg(8) = 'FPG4NOS'
!
    else if (elrefa.eq.'QU8') then
        vol = 4.d0
!
        nbfpg = 7
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 9, 9, 8]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG9'
        fapg(6) = 'FPG9COQ'
        fapg(7) = 'FPG4NOS'
!
    else if (elrefa.eq.'QU9') then
        vol = 4.d0
!
        nbfpg = 6
        nbpg(1:nbfpg) = [nno, nnos, 1, 4, 9, 9]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG4'
        fapg(5) = 'FPG9'
        fapg(6) = 'FPG9COQ'
!
    else if (elrefa.eq.'PO1') then
        vol = 1.d0
!
        nbfpg = 3
        nbpg(1:nbfpg) = [1, 1, 1]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
!
    else if (elrefa.eq.'SE2') then
        vol = 2.d0
!
        nbfpg = 13
        nbpg(1:nbfpg) = [nno, nnos, 1, 2, 3, 4, 3, 5, 4, 5, 10, nnos+2, nnos+3]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG2'
        fapg(5) = 'FPG3'
        fapg(6) = 'FPG4'
        fapg(7) = 'SIMP'
        fapg(8) = 'SIMP1'
        fapg(9) = 'COTES'
        fapg(10) = 'COTES1'
        fapg(11) = 'COTES2'
        fapg(12) = 'FPG2NOS'
        fapg(13) = 'FPG3NOS'
!
    else if (elrefa.eq.'SE3') then
        vol = 2.d0
!
        nbfpg = 10
        nbpg(1:nbfpg) = [nno, nnos, 1, 2, 3, 4, 3, 4, nnos+2, nnos+3]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG2'
        fapg(5) = 'FPG3'
        fapg(6) = 'FPG4'
        fapg(7) = 'SIMP'
        fapg(8) = 'COTES'
        fapg(9) = 'FPG2NOS'
        fapg(10) = 'FPG3NOS'
!
    else if (elrefa.eq.'SE4') then
        vol = 2.d0
!
        nbfpg = 8
        nbpg(1:nbfpg) = [nno, nnos, 1, 2, 3, 4, 3, 4]
!
        fapg(1) = 'NOEU'
        fapg(2) = 'NOEU_S'
        fapg(3) = 'FPG1'
        fapg(4) = 'FPG2'
        fapg(5) = 'FPG3'
        fapg(6) = 'FPG4'
        fapg(7) = 'SIMP'
        fapg(8) = 'COTES'
!
    else
        ASSERT(ASTER_FALSE)
    endif
!
    do i = 1, nno
        deca = ndim * (i -1)
        if (ndim .ge. 1) x(deca+1) = coorno(1,i)
        if (ndim .ge. 2) x(deca+2) = coorno(2,i)
        if (ndim .eq. 3) x(deca+3) = coorno(3,i)
    end do
!
end subroutine

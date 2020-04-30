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
subroutine elrfno(elrefz, nno, nnos, ndim, coorno)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
character(len=*), intent(in)        :: elrefz
integer, intent(out)                :: nno
integer, optional, intent(out)      :: ndim, nnos
real(kind=8), optional, intent(out) :: coorno(3,27)
!
! --------------------------------------------------------------------------------------------------
! BUT:   CARACTERISTIQUE DE ELREFE
!
! --------------------------------------------------------------------------------------------------
!   IN   ELREFZ : NOM DE L'ELREFE (K8)
!   OUT  NDIM   : DIMENSION TOPOLOGIQUE : 0/1/2/3 (OPTIONAL)
!        NNO    : NOMBRE DE NOEUDS
!        NNOS   : NOMBRE DE NOEUDS SOMMETS (OPTIONAL)
!        COORNO : COORDONNEES DES NOEUDS (OPTIONAL)
! --------------------------------------------------------------------------------------------------
!
    integer :: nnos_, ndim_
    real(kind=8), parameter :: untiers = 1.d0 / 3.d0
!
    nnos_ = 0
    ndim_ = 0
!
    if(present(coorno)) then
        coorno = 0.d0
    end if
!
    select case (elrefz)
        case('HE8')
            nno   = 8
            nnos_ = 8
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:8) = [-1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0, -1.d0]
                coorno(2,1:8) = [-1.d0, -1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0]
                coorno(3,1:8) = [-1.d0, -1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0, +1.d0]
            end if
        case('H20')
            nno   = 20
            nnos_ = 8
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:8) = [-1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0, -1.d0]
                coorno(2,1:8) = [-1.d0, -1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0]
                coorno(3,1:8) = [-1.d0, -1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0, +1.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,9:20) = [ 0.d0, +1.d0,  0.d0, -1.d0, -1.d0, +1.d0, +1.d0, -1.d0, &
                                   0.d0, +1.d0,  0.d0, -1.d0]
                coorno(2,9:20) = [-1.d0,  0.d0, +1.d0,  0.d0, -1.d0, -1.d0, +1.d0, +1.d0, &
                                  -1.d0,  0.d0, +1.d0,  0.d0]
                coorno(3,9:20) = [-1.d0, -1.d0, -1.d0, -1.d0,  0.d0,  0.d0,  0.d0,  0.d0, &
                                  +1.d0, +1.d0, +1.d0, +1.d0]
            end if
        case('H27')
            nno   = 27
            nnos_ = 8
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:8) = [-1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0, -1.d0]
                coorno(2,1:8) = [-1.d0, -1.d0, +1.d0, +1.d0, -1.d0, -1.d0, +1.d0, +1.d0]
                coorno(3,1:8) = [-1.d0, -1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0, +1.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,9:20) = [ 0.d0, +1.d0,  0.d0, -1.d0, -1.d0, +1.d0, +1.d0, -1.d0, &
                                   0.d0, +1.d0,  0.d0, -1.d0]
                coorno(2,9:20) = [-1.d0,  0.d0, +1.d0,  0.d0, -1.d0, -1.d0, +1.d0, +1.d0, &
                                  -1.d0,  0.d0, +1.d0,  0.d0]
                coorno(3,9:20) = [-1.d0, -1.d0, -1.d0, -1.d0,  0.d0,  0.d0,  0.d0,  0.d0, &
                                  +1.d0, +1.d0, +1.d0, +1.d0]
!
!    NOEUDS MILIEUX DES FACES ET BARYCENTRE
!
                coorno(1,21:27) = [ 0.d0,  0.d0, +1.d0,  0.d0, -1.d0,  0.d0, 0.d0]
                coorno(2,21:27) = [ 0.d0, -1.d0,  0.d0, +1.d0,  0.d0,  0.d0, 0.d0]
                coorno(3,21:27) = [-1.d0,  0.d0,  0.d0,  0.d0,  0.d0, +1.d0, 0.d0]
            end if
        case('PE6')
            nno   = 6
            nnos_ = 6
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:6) = [-1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0]
                coorno(2,1:6) = [+1.d0,  0.d0,  0.d0, +1.d0,  0.d0,  0.d0]
                coorno(3,1:6) = [ 0.d0, +1.d0,  0.d0,  0.d0, +1.d0,  0.d0]
            end if
        case('P15')
            nno   = 15
            nnos_ = 6
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:6) = [-1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0]
                coorno(2,1:6) = [+1.d0,  0.d0,  0.d0, +1.d0,  0.d0,  0.d0]
                coorno(3,1:6) = [ 0.d0, +1.d0,  0.d0,  0.d0, +1.d0,  0.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,7:15) = [-1.d0, -1.d0, -1.d0,  0.d0,  0.d0,  0.d0, +1.d0, +1.d0, +1.d0]
                coorno(2,7:15) = [0.5d0,  0.d0, 0.5d0, +1.d0,  0.d0,  0.d0, 0.5d0,  0.d0,  0.5d0]
                coorno(3,7:15) = [0.5d0, 0.5d0,  0.d0,  0.d0, +1.d0,  0.d0, 0.5d0,  0.5d0, 0.d0]
            end if
        case('P18')
            nno   = 18
            nnos_ = 6
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:6) = [-1.d0, -1.d0, -1.d0, +1.d0, +1.d0, +1.d0]
                coorno(2,1:6) = [+1.d0,  0.d0,  0.d0, +1.d0,  0.d0,  0.d0]
                coorno(3,1:6) = [ 0.d0, +1.d0,  0.d0,  0.d0, +1.d0,  0.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,7:15) = [-1.d0, -1.d0, -1.d0,  0.d0,  0.d0,  0.d0, +1.d0, +1.d0, +1.d0]
                coorno(2,7:15) = [0.5d0,  0.d0, 0.5d0, +1.d0,  0.d0,  0.d0, 0.5d0,  0.d0,  0.5d0]
                coorno(3,7:15) = [0.5d0, 0.5d0,  0.d0,  0.d0, +1.d0,  0.d0, 0.5d0,  0.5d0, 0.d0]
!
!    NOEUDS MILIEUX DES FACES ET BARYCENTRE
!
                coorno(1,16:18) = [ 0.d0,   0.d0,   0.d0]
                coorno(2,16:18) = [ 0.5d0,  0.d0,   0.5d0]
                coorno(3,16:18) = [ 0.5d0,  0.5d0,  0.d0]
            end if
        case('TE4')
            nno   = 4
            nnos_ = 4
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:4) = [ 0.d0,  0.d0,  0.d0, +1.d0]
                coorno(2,1:4) = [+1.d0,  0.d0,  0.d0,  0.d0]
                coorno(3,1:4) = [ 0.d0, +1.d0,  0.d0,  0.d0]
            end if
        case('T10')
            nno   = 10
            nnos_ = 4
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:4)=[ 0.d0,  0.d0,  0.d0, +1.d0]
                coorno(2,1:4)=[+1.d0,  0.d0,  0.d0,  0.d0]
                coorno(3,1:4)=[ 0.d0, +1.d0,  0.d0,  0.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,5:10) = [ 0.d0,   0.d0,  0.d0,  0.5d0, 0.5d0, 0.5d0]
                coorno(2,5:10) = [ 0.5d0,  0.d0,  0.5d0, 0.5d0, 0.d0,  0.d0]
                coorno(3,5:10) = [ 0.5d0,  0.5d0, 0.d0,  0.d0,  0.5d0, 0.d0]
            end if
        case('TE8')
            nno   = 8
            nnos_ = 4
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:4)=[ 0.d0,  0.d0,  0.d0, +1.d0]
                coorno(2,1:4)=[+1.d0,  0.d0,  0.d0,  0.d0]
                coorno(3,1:4)=[ 0.d0, +1.d0,  0.d0,  0.d0]
!
!   NOEUDS MILIEUX DES FACES
!
                coorno(1,5:8) = [    0.d0,  untiers,  untiers,  untiers]
                coorno(2,5:8) = [ untiers,  untiers,  untiers,     0.d0]
                coorno(3,5:8) = [ untiers,  untiers,     0.d0,  untiers]
            end if
        case('PY5')
            nno   = 5
            nnos_ = 5
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:5) = [+1.d0,  0.d0, -1.d0,  0.d0,  0.d0]
                coorno(2,1:5) = [ 0.d0, +1.d0,  0.d0, -1.d0,  0.d0]
                coorno(3,1:5) = [ 0.d0,  0.d0,  0.d0,  0.d0, +1.d0]
            end if
        case('P13')
            nno   = 13
            nnos_ = 5
            ndim_ = 3
!
            if(present(coorno)) then
!
!   NOEUDS SOMMETS
!
                coorno(1,1:5) = [+1.d0,  0.d0, -1.d0,  0.d0,  0.d0]
                coorno(2,1:5) = [ 0.d0, +1.d0,  0.d0, -1.d0,  0.d0]
                coorno(3,1:5) = [ 0.d0,  0.d0,  0.d0,  0.d0, +1.d0]
!
!   NOEUDS MILIEUX DES ARETES
!
                coorno(1,6:13) = [ 0.5d0, -0.5d0, -0.5d0,  0.5d0,  0.5d0,  0.d0,  -0.5d0,  0.d0]
                coorno(2,6:13) = [ 0.5d0,  0.5d0, -0.5d0, -0.5d0,  0.d0,   0.5d0,  0.d0,  -0.5d0]
                coorno(3,6:13) = [ 0.d0,   0.d0,   0.d0,   0.d0,   0.5d0,  0.5d0,  0.5d0,  0.5d0]
            end if
        case('TR3')
            nno   = 3
            nnos_ = 3
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [0.d0, +1.d0,  0.d0]
                coorno(2,1:nno) = [0.d0,  0.d0, +1.d0]
            end if
        case('TR4')
            nno   = 4
            nnos_ = 3
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [0.d0, +1.d0,  0.d0, untiers]
                coorno(2,1:nno) = [0.d0,  0.d0, +1.d0, untiers]
            end if
        case('TR6')
            nno   = 6
            nnos_ = 3
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [0.d0, +1.d0,  0.d0, 0.5d0, 0.5d0, 0.d0]
                coorno(2,1:nno) = [0.d0,  0.d0, +1.d0, 0.d0 , 0.5d0, 0.5d0]
            end if
        case('TR7')
            nno   = 7
            nnos_ = 3
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [0.d0, +1.d0,  0.d0, 0.5d0, 0.5d0, 0.d0,  untiers]
                coorno(2,1:nno) = [0.d0,  0.d0, +1.d0, 0.d0 , 0.5d0, 0.5d0, untiers]
            end if
        case('QU4')
            nno   = 4
            nnos_ = 4
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [-1.d0, +1.d0, +1.d0, -1.d0]
                coorno(2,1:nno) = [-1.d0, -1.d0, +1.d0, +1.d0]
            end if
        case('QU8')
            nno   = 8
            nnos_ = 4
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [-1.d0, +1.d0, +1.d0, -1.d0,  0.d0, +1.d0,  0.d0 , -1.d0]
                coorno(2,1:nno) = [-1.d0, -1.d0, +1.d0, +1.d0, -1.d0,  0.d0, +1.d0,   0.d0]
            end if
        case('QU9')
            nno   = 9
            nnos_ = 4
            ndim_ = 2
!
            if(present(coorno)) then
                coorno(1,1:nno) = [-1.d0, +1.d0, +1.d0, -1.d0,  0.d0, +1.d0,  0.d0 , -1.d0, 0.d0]
                coorno(2,1:nno) = [-1.d0, -1.d0, +1.d0, +1.d0, -1.d0,  0.d0, +1.d0,   0.d0, 0.d0]
            end if
        case('SE2')
            nno   = 2
            nnos_ = 2
            ndim_ = 1
!
            if(present(coorno)) then
                coorno(1,1:nno) = [-1.d0, +1.d0]
            end if
        case('SE3')
            nno   = 3
            nnos_ = 2
            ndim_ = 1
!
            if(present(coorno)) then
                coorno(1,1:nno) = [ -1.d0, +1.d0, 0.d0]
            end if
        case('SE4')
            nno   = 4
            nnos_ = 2
            ndim_ = 1
!
            if(present(coorno)) then
                coorno(1,1:nno) = [-1.d0, +1.d0, -1.d0/3.d0, 1.d0/3.d0]
            end if
        case('PO1')
            nno   = 1
            nnos_ = 1
            ndim_ = 0
!
            if(present(coorno)) then
                coorno(1,1) = 0.d0
            end if
        case default
            ASSERT(ASTER_FALSE)
    end select
!
    if(present(nnos)) then
        nnos = nnos_
    end if
!
    if(present(ndim)) then
        ndim = ndim_
    end if
!
end subroutine

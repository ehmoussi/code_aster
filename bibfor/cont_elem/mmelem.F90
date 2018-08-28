! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine mmelem(nomte , ndim , nddl,&
                  typmae, nne  ,&
                  typmam, nnm  ,&
                  nnl   , nbcps, nbdm,&
                  laxis , leltf)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lteatt.h"
!
character(len=16), intent(in) :: nomte
integer, intent(out) :: ndim, nddl, nne, nnm, nnl
integer, intent(out) :: nbcps, nbdm
character(len=8), intent(out) :: typmae, typmam
aster_logical, intent(out) :: laxis, leltf
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get informations on cells (slave and master)
!
! --------------------------------------------------------------------------------------------------
!
! In  nomte            : type of finite element
! Out ndim             : dimension of problem (2 or 3)
! Out nddl             : total number of dof
! Out nne              : number of slave nodes
! Out nnm              : number of master nodes
! Out nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! Out nbcps            : number of components by node for Lagrange multiplicators
! Out nbdm             : number of components by node for all dof
! Out typmae           : type of slave element
! Out typmam           : type of master element
! Out laxis            : flag for axisymmetric
! Out leltf            : flag for friction
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i2d, i3d
!
! --------------------------------------------------------------------------------------------------
!
    laxis = lteatt('AXIS','OUI')
    leltf = lteatt('FROTTEMENT','OUI')
!
    if (leltf) then
! ----- COMPOSANTES 2D : LAGS_C   LAGS_F1
! ----- COMPOSANTES 3D : LAGS_C   LAGS_F1  LAGS_F2
        i2d = 2
        i3d = 3
    else
! ----- COMPOSANTE : LAGS_C
        i2d = 1
        i3d = 1
    endif
!
! --- 2D
!
! --- 'SE2'
    if (nomte(1:6) .eq. 'CFS2S2' .or. nomte(1:6) .eq. 'COS2S2') then
        ndim = 2
        typmae = 'SE2'
        nne = 2
        typmam = 'SE2'
        nnm = 2
        nddl = nnm*ndim + nne*(ndim+i2d)
    else if (nomte(1:6).eq.'CFS2S3' .or. nomte(1:6).eq.'COS2S3') then
        ndim = 2
        typmae = 'SE2'
        nne = 2
        typmam = 'SE3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i2d)
! --- 'SE3'
    else if (nomte(1:6).eq.'CFS3S2' .or. nomte(1:6).eq.'COS3S2') then
        ndim = 2
        typmae = 'SE3'
        nne = 3
        typmam = 'SE2'
        nnm = 2
        nddl = nnm*ndim + nne*(ndim+i2d)
    else if (nomte(1:6).eq.'CFS3S3' .or. nomte(1:6).eq.'COS3S3') then
        ndim = 2
        typmae = 'SE3'
        nne = 3
        typmam = 'SE3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i2d)
!
! --- 3D
!
! --- 'SE2'
    else if (nomte.eq.'CFP2P2' .or. nomte.eq.'COP2P2') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'SE2'
        nnm = 2
        nddl = nnm*ndim + nne*(ndim+i3d)
! --- 'TR3'
    else if (nomte.eq.'CFT3T3' .or. nomte.eq.'COT3T3') then
        ndim = 3
        typmae = 'TR3'
        nne = 3
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT3T6' .or. nomte.eq.'COT3T6') then
        ndim = 3
        typmae = 'TR3'
        nne = 3
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT3Q4' .or. nomte.eq.'COT3Q4') then
        ndim = 3
        typmae = 'TR3'
        nne = 3
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT3Q8' .or. nomte.eq.'COT3Q8') then
        ndim = 3
        typmae = 'TR3'
        nne = 3
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT3Q9' .or. nomte.eq.'COT3Q9') then
        ndim = 3
        typmae = 'TR3'
        nne = 3
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
! --- 'TR6'
    else if (nomte.eq.'CFT6T3' .or. nomte.eq.'COT6T3') then
        ndim = 3
        typmae = 'TR6'
        nne = 6
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT6T6' .or. nomte.eq.'COT6T6') then
        ndim = 3
        typmae = 'TR6'
        nne = 6
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT6Q4' .or. nomte.eq.'COT6Q4') then
        ndim = 3
        typmae = 'TR6'
        nne = 6
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT6Q8' .or. nomte.eq.'COT6Q8') then
        ndim = 3
        typmae = 'TR6'
        nne = 6
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFT6Q9' .or. nomte.eq.'COT6Q9') then
        ndim = 3
        typmae = 'TR6'
        nne = 6
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
! --- 'QU4'
    else if (nomte.eq.'CFQ4T3' .or. nomte.eq.'COQ4T3') then
        ndim = 3
        typmae = 'QU4'
        nne = 4
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ4T6' .or. nomte.eq.'COQ4T6') then
        ndim = 3
        typmae = 'QU4'
        nne = 4
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ4Q4' .or. nomte.eq.'COQ4Q4') then
        ndim = 3
        typmae = 'QU4'
        nne = 4
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ4Q8' .or. nomte.eq.'COQ4Q8') then
        ndim = 3
        typmae = 'QU4'
        nne = 4
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ4Q9' .or. nomte.eq.'COQ4Q9') then
        ndim = 3
        typmae = 'QU4'
        nne = 4
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
! --- 'QU8'
    else if (nomte.eq.'CFQ8T3' .or. nomte.eq.'COQ8T3') then
        ndim = 3
        typmae = 'QU8'
        nne = 8
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ8T6' .or. nomte.eq.'COQ8T6') then
        ndim = 3
        typmae = 'QU8'
        nne = 8
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ8Q4' .or. nomte.eq.'COQ8Q4') then
        ndim = 3
        typmae = 'QU8'
        nne = 8
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ8Q8' .or. nomte.eq.'COQ8Q8') then
        ndim = 3
        typmae = 'QU8'
        nne = 8
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ8Q9' .or. nomte.eq.'COQ8Q9') then
        ndim = 3
        typmae = 'QU8'
        nne = 8
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
! --- 'QU9'
    else if (nomte.eq.'CFQ9T3' .or. nomte.eq.'COQ9T3') then
        ndim = 3
        typmae = 'QU9'
        nne = 9
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ9T6' .or. nomte.eq.'COQ9T6') then
        ndim = 3
        typmae = 'QU9'
        nne = 9
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ9Q4' .or. nomte.eq.'COQ9Q4') then
        ndim = 3
        typmae = 'QU9'
        nne = 9
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ9Q8' .or. nomte.eq.'COQ9Q8') then
        ndim = 3
        typmae = 'QU9'
        nne = 9
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFQ9Q9' .or. nomte.eq.'COQ9Q9') then
        ndim = 3
        typmae = 'QU9'
        nne = 9
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS2T3' .or. nomte.eq.'COS2T3') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS2T6' .or. nomte.eq.'COS2T6') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS2Q4' .or. nomte.eq.'COS2Q4') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS2Q8' .or. nomte.eq.'COS2Q8') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS2Q9' .or. nomte.eq.'COS2Q9') then
        ndim = 3
        typmae = 'SE2'
        nne = 2
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS3T3' .or. nomte.eq.'COS3T3') then
        ndim = 3
        typmae = 'SE3'
        nne = 3
        typmam = 'TR3'
        nnm = 3
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS3T6' .or. nomte.eq.'COS3T6') then
        ndim = 3
        typmae = 'SE3'
        nne = 3
        typmam = 'TR6'
        nnm = 6
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS3Q4' .or. nomte.eq.'COS3Q4') then
        ndim = 3
        typmae = 'SE3'
        nne = 3
        typmam = 'QU4'
        nnm = 4
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS3Q8' .or. nomte.eq.'COS3Q8') then
        ndim = 3
        typmae = 'SE3'
        nne = 3
        typmam = 'QU8'
        nnm = 8
        nddl = nnm*ndim + nne*(ndim+i3d)
    else if (nomte.eq.'CFS3Q9' .or. nomte.eq.'COS3Q9') then
        ndim = 3
        typmae = 'SE3'
        nne = 3
        typmam = 'QU9'
        nnm = 9
        nddl = nnm*ndim + nne*(ndim+i3d)
    else
        ASSERT(.false.)
    endif
!
! --- NOMBRE DE NOEUDS PORTANT DES LAGRANGES
!
    nnl = nne
!
! --- NOMBRE DE COMPOSANTES LAGR_C + LAGR_F
!
    if (leltf) then
        nbcps = ndim
    else
        nbcps = 1
    endif
!
! --- NOMBRE DE COMPOSANTES TOTAL DEPL + LAGR_C + LAGR_F
!
    nbdm = ndim + nbcps
!
    ASSERT(nddl.le.81)
    ASSERT((ndim.eq.2).or.(ndim.eq.3))
!
end subroutine

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

!
#include "asterf_types.h"
interface 
      subroutine  criter3d(sig16p,bg,pg,bw,pw,&
               rt33p,rtg33p,ref33p,rc,epicc,&
               epleq,epspt6p,epspg6p,&
               delta,beta,nc,ig,fg,&
               na,fa,dpfa_ds,dgfa_ds,dpfa_dpg,&
               dra_dl,souplesse66p,err1,depleq_dl,&
               irr,fglim,&
               kg,hpla,ekdc,&
               hplg,dpfa_dr,tauc,&
               epeqpc)
        real(kind=8) :: sig16p(6)
        real(kind=8) :: bg
        real(kind=8) :: pg
        real(kind=8) :: bw
        real(kind=8) :: pw
        real(kind=8) :: rt33p(3,3)
        real(kind=8) :: rtg33p(3,3)
        real(kind=8) :: ref33p(3,3)
        real(kind=8) :: rc
        real(kind=8) :: epicc
        real(kind=8) :: epleq
        real(kind=8) :: epspt6p(6)
        real(kind=8) :: epspg6p(6)
        real(kind=8) :: delta
        real(kind=8) :: beta
        integer :: nc
        integer :: ig(nc)
        real(kind=8) :: fg(nc)
        integer :: na
        real(kind=8) :: fa(nc)
        real(kind=8) :: dpfa_ds(nc,6)
        real(kind=8) :: dgfa_ds(nc,6)
        real(kind=8) :: dpfa_dpg(nc)
        real(kind=8) :: dra_dl(nc)
        real(kind=8) :: souplesse66p(6,6)
        integer :: err1
        real(kind=8) :: depleq_dl
        integer :: irr
        real(kind=8) :: fglim(nc)
        real(kind=8) :: epsmt3p(3)
        real(kind=8) :: kg
        real(kind=8) :: hpla
        real(kind=8) :: ekdc
        real(kind=8) :: hplg
        real(kind=8) :: dpfa_dr(nc)
        real(kind=8) :: tauc 
        real(kind=8) :: epeqpc 
    end subroutine criter3d
end interface 

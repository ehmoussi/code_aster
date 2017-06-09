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

subroutine csheff_3d(dcash, dcsheff, dalpha, sic, csh,&
                     alsol, dalsol, csheff, xidtot, xidtot1,&
                     nasol, vnasol, dt, alpha, cash,&
                     alc, sc, id0, id1, id2)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul des vitesses de csheff
!=====================================================================
    implicit none
    real(kind=8) :: dcash
    real(kind=8) :: dcsheff
    real(kind=8) :: dalpha
    real(kind=8) :: sic
    real(kind=8) :: csheff
    real(kind=8) :: csh
    real(kind=8) :: alsol
    real(kind=8) :: dalsol
    real(kind=8) :: cash
    real(kind=8) :: dt
    real(kind=8) :: vnasol
    real(kind=8) :: nasol
    real(kind=8) :: alc
    real(kind=8) :: sc
    real(kind=8) :: alpha
    real(kind=8) :: id0
    real(kind=8) :: id1
    real(kind=8) :: id2
    real(kind=8) :: xidtot
    real(kind=8) :: xidtot1
    real(kind=8) :: frac0
    real(kind=8) :: bsup
    real(kind=8) :: binf
    real(kind=8) :: xid0
    real(kind=8) :: xidseuil
    real(kind=8) :: xidtotref
    real(kind=8) :: bmax
!     fraction de csh participant à la fixation csheff/csh      
!      frac=0.275d0
    xid0=id0
    xidtotref=id1
    xidseuil=id2
!
!      nasolref=0.5d0
!      nasol1=nasol+vnasol*dt
!      frac0=(1.d0-exp(-xidtot/xidtotref))*exp(-nasol/nasolref)
!     calcul bornes de frac par résolution du système d'adenot
    bsup=(alpha*alc-(2.d0/3.d0)*sc*alpha)/csh
    binf=(alpha*alc-2.d0*sc*alpha)/csh
    bmax=(alpha*alc)/csh    
    if ((xidtot.ge.xid0) .and. (xidtot.le.xidtotref)) then
        frac0=binf+((bsup-binf)/(xidtotref-xid0))*xidtot
    else if ((xidtot.gt.xidtotref).and.(xidtot.le.xidseuil)) then
        frac0=bsup+((bmax-bsup)/(xidseuil-xidtotref))*(xidtot-xidtotref)
    else if (xidtot.gt.xidseuil) then
        frac0=bmax
    else
        frac0=binf      
    end if 
!      frac0=binf+(bsup-binf)*(1.d0-exp(-xidtot/xidtotref)) 
!      frac0=0.13+0.18*(1.d0-exp(-xidtot/xidtotref))        
!      frac1=(1.d0-exp(-xidtot1/xidtotref))*exp(-nasol1/nasolref)  
!      dfrac=frac1-frac0      
!      dcsheff=(dalpha*sic)*frac0+csh*dfrac-dcash
    csheff=max((alpha*sic*frac0-cash),1.d-4)
!      print*,frac0
end subroutine

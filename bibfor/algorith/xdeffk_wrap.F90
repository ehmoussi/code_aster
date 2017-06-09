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

subroutine xdeffk_wrap(kappa, mu, r, theta, ndim, fkpo, option, istano)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/xdeffk.h"
#include "asterc/r8depi.h"
#include "asterc/r8prem.h"
!
    integer :: ndim, istano
    real(kind=8) :: r, theta, fkpo(ndim,ndim), kappa, mu
    character(len=*) :: option
!
!
!     BUT:  FONCTIONS D'ENRICHISSEMENT DANS LA BASE POLAIRE (R,THETA)
!
! IN  R      : PREMIERE COORDONNEE DANS LA BASE POLAIRE
! IN  THETA  : SECONDE COORDONNEE DANS LA BASE POLAIRE
! OUT FKPO     : VALEURS DES FONCTIONS D'ENRICHISSEMENT <VECTORIELLES>
!
!---------------------------------------------------------------
!
    character(len=8) :: pref
!
    pref=option
!    if (istano.eq.-2) pref='SMOOTH'
!
    call xdeffk(kappa, mu, r, theta, ndim, fkpo)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if     (pref.eq.'DEFAULT') then
      goto 999
!
    elseif (pref.eq.'BASIC') then
      fkpo(1:ndim,1:ndim)=0.
      fkpo(1,1:2)=[sqrt(r)*cos(theta/2.d0),sqrt(r)*sin(theta/2.d0)]
      fkpo(2,1:2)=[sqrt(r)*sin(theta/2.d0),sqrt(r)*cos(theta/2.d0)]
      if (ndim.eq.3) fkpo(3,3)=sqrt(r)*sin(theta/2.d0)
!
    elseif (pref.eq.'SMOOTH') then
      if (r.gt.r8prem()) then
         fkpo=fkpo/sqrt(r)
      endif
!
    elseif (pref.eq.'JUMP') then
      fkpo=2.d0*mu*sqrt(r8depi())*fkpo/(kappa+1)    
      !fkpo(1:2,1:2)=2.d0*mu*sqrt(r8depi())*fkpo(1:2,1:2)/(kappa+1)
!
    endif
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
999 continue
!
end subroutine

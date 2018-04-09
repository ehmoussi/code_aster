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

subroutine hydrxmat(xmat0,xmat1,hydra1,hydras,n,&
                                          erreur)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   effet de l hydratation sur les caracteristiques materiau
!   declaration externe
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/utmess.h"
      real(kind=8) :: xmat0,xmat1,hydra1,hydras,n
      integer erreur
!   declaration locale      
      real(kind=8) :: yy,zzmin,hydra
!   avant le seuil d hydratation on a 1e-3 des cracateristiques       
      parameter (zzmin=1.0d-3)
!   initialisation controle d erreur      
      erreur=0
      if((hydras.le.0.).or.(hydras.gt.(1.d0-zzmin))) then
             call utmess('E', 'COMPOR3_38')
             print*,xmat0,xmat1,hydra1,hydras,n
             xmat1=xmat0
             erreur=1
      end if      
      if (hydra1.le.(hydras+zzmin))then
         hydra=hydras+zzmin
      else
         hydra=hydra1
      end if
      hydra=dmin1(hydra,1.d0)
      if(abs(hydra-1.d0).ge.r8prem())then
         yy=(hydra-hydras)/(1.d0-hydras)
         xmat1=xmat0*(yy**n)
      else
         xmat1=xmat0
      end if
end subroutine

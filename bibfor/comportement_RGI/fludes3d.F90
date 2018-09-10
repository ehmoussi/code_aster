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

subroutine fludes3d(bw0,pw0,bw,pw,sfld,&
                    sig0,dsw6,nstrs)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
       implicit none
#include "asterc/r8prem.h"
#include "asterfort/x6x33.h"
#include "asterfort/b3d_valp33.h"
#include "asterfort/transpos1.h"
#include "asterfort/chrep6.h"    

      

!   surcharge capillaire en fluage de dessication

!     variables externes
      integer nstrs
      real(kind=8) :: sig0(:)
      real(kind=8) :: bw0,pw0,bw,pw,sfld,sig16(6),dsw6(6)

!     variables locales
      real(kind=8) :: sig133(3,3),sig13(3),vsig133(3,3),vsig133t(3,3),dsw6p(6)
      integer i 
      real(kind=8) :: dbwpw 

      dbwpw=0.d0

!     actualisation de la surcharge capillaire
      dbwpw=(bw*pw-bw0*pw0)
      if (abs(dbwpw).ge.r8prem()) then

!     complement vecteur des contraintes init si nstrs ne 6      
      do i=1,nstrs
        sig16(i)=sig0(i)
      end do
      if(nstrs.lt.6) then
        do i=(nstrs+1),6
            sig16(i)=0.d0
        end do
      end if      
!     diagonalisationdes contraintes totales
      call x6x33(sig16,sig133)         
!     call valp3d(sig133,sig13,vsig133)
      call b3d_valp33(sig133,sig13,vsig133)
!     construction matrice de passage inverse         
      call transpos1(vsig133t,vsig133,3)
!     passage de la surcharge capillaire dans la base prin actuelle
      call chrep6(dsw6,vsig133,.false._1,dsw6p)
      do i=1,3
        dsw6p(i)=dsw6p(i)-dbwpw*dabs(sig13(i)/sfld)
      end do
!     retour en base fixe
      call chrep6(dsw6p,vsig133t,.false._1,dsw6)      
      end if
end subroutine

 

 
 

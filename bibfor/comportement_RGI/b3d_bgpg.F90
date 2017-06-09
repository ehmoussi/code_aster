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

subroutine b3d_bgpg(vg, biot0, poro0, xmg, vp0,&
                    bg, epsvt, epsvpg, epsvpw, pg)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!********************************************************************** 
!     calcul de la pression de gel      
    implicit none
    real(kind=8) :: vg
    real(kind=8) :: biot0
    real(kind=8) :: poro0
    real(kind=8) :: xmg
    real(kind=8) :: vp0
    real(kind=8) :: bg
    real(kind=8) :: epsvt
    real(kind=8) :: epsvpg
    real(kind=8) :: epsvpw
    real(kind=8) :: pg, vptg
!     prise en compte du degre de saturation en gel de la porosite
!     dans le coeff de Biot  (bg)    
!c      bg=biot0*min((vg/poro0),1.d0)
!     Modif Paulo Regis et Multon  : retour a la version grimal mais avec biot reel
!     (on omet le degre de saturation : ie le gel accede a toute l augmentation de volume)
    bg=biot0
!     calcul du volume de decharge du gel      
!     prise en compte du volume connecte (vp0), de la contribution
!     de la defeormation viscoelastique du squelette (Bg*(...)
!     et du volume des fissures connectees au site reactifs (epsvpg)      
    vptg=vp0+bg*(epsvt-epsvpg-epsvpw)+epsvpg 
!c     prise en compte de la condition de surpression (pg>0)     
    if (vg .gt. vptg) then
        pg=xmg*(vg-vptg)
!c       print*,'pg fin', pg
    else
        pg=0.d0
    end if
end subroutine

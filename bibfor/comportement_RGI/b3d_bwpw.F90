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

subroutine b3d_bwpw(biot0, vw0, xsat, poro0, epsvt,&
                    epsvpw, epsvpg, vg, pw1, bw1,&
                    xnsat, mfr1, pw0, dpw, vw1)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!     calcul de la pression hydrique en sature et non sature      
!===================================================================
    implicit none
    integer :: mfr1
    real(kind=8) :: biot0
    real(kind=8) :: vw0
    real(kind=8) :: xsat
    real(kind=8) :: poro0
    real(kind=8) :: epsvt
    real(kind=8) :: epsvpw
    real(kind=8) :: epsvpg
    real(kind=8) :: vg
    real(kind=8) :: pw1
    real(kind=8) :: bw1
    real(kind=8) :: xnsat
    real(kind=8) :: pw0
    real(kind=8) :: dpw
    real(kind=8) :: vw1, vvw1, dvvw1, dpw1
!
    if (mfr1 .ne. 33) then
!      formulation non poreuse
!      Biot reel de l eau integrant le degre de saturation
!       bw1=biot0*min((vw1/poro0),1.d0)
!      modif juin 2013 ; biot independant de Sr tout est dans pw
!      attention si bw1 ne biot0 modif complementaire dans endo3d fluag3d
        bw1=biot0
!      volume accessible a l eau
        vvw1=poro0+bw1*(epsvt-epsvpw-epsvpg)+epsvpw-vg
!      print*,poro0,bw1,epsvt,epsvpw,epsvpg,vg 
!      calcul de la pression et du coeff de Biot      
        if (vw1 .gt. vvw1) then
!        surpression (xmw=2040 MPa à 20°C)
            pw1=xsat*(vw1-vvw1)
!         PRINT*,'epsvt',epsvt,'PRESSION D EAU',PW1,'biot',biot0
        else
!        depression (xmw*biot*sr=1040 MPa à 20°C soit xmw0/2 environ)
!        cf article EJECE calage Granger
            pw1=xnsat*(vw1-vvw1)
!         print*,'ds b3d_bwpw',pw1,xnsat,vw1,vvw1
!         read*
!        modif Multon avril 2013 : on retablit la non linerarite du retrait
!        par rapport a la perte de masse
!         bw1=biot0         
!         PRINT*,'epsvt',epsvt,'PRESSION D EAU',PW1
        end if
!      print*,'pw=',pw1,xnsa,vw0,vvw0
!      if (pw1.gt.0.)then
!       print*,poro0,bw1,epsvt,epsvpw,epsvpg,vg 
!       read*
!      end if
!      on peut calculer l increment de pression sur le pas
        dpw=pw1-pw0
    else
!      formulation poreuse la pression n est pas traitee au point de gauss
!      on la stocke dans le vari en cas de non sature ou pour controler
        pw1=pw0+dpw
!       print*,'volume d eau dans b3d bwpw', vw0
!       print*,'pression castem fin de pas',pw1
!      Biot reel de l eau integrant le degre de saturation
!      modif juin 2013 biot cst tout est dans pw
!       bw1=biot0*min((vw1/poro0),1.d0)
!      attention si bw1 ne biot0 modif complementaire dans endo3 fluag3d...
        bw1=biot0
!      volume accessible a l eau non comptabilise par la formulation poreuse du code
        dvvw1=bw1*(-epsvpw-epsvpg)+epsvpw-vg
        if (pw1 .gt. 0.) then
            dpw1=-xsat*dvvw1
        else
            dpw1=-xnsat*dvvw1
        end if 
    end if
end subroutine

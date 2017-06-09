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

subroutine kfomvg(pr, sr, m, n, usm,&
                  usn, s1, krl, krg, dklds,&
                  dkgds)
!
! KFOMVG : CALCUL DES PERMEABILITES RELATIVES
!         PAR FONCTION MUALEM-VAN-GENUCHTEN
!
    implicit      none
!
! IN
    real(kind=8) :: pr, sr, m, n, usm, usn, s1
! OUT
    real(kind=8) :: krl, krg, dklds, dkgds
! LOCAL
    real(kind=8) :: umsr, usumsr, a
!
    umsr=(1.d0-sr)
    usumsr=1.d0/umsr
    krl=(s1**0.5d0)*((1.d0-(1.d0-s1**usm)**m)**2.d0)
    krg=((1.d0-s1)**0.5d0)*((1.d0-s1**usm)**(2.d0*m))
    a=1.d0-s1**usm
    dklds=usumsr*(krl/(2.d0*s1)+2.d0*((s1)**0.5d0)*(1.d0-a**m)&
     &       *(a**(m-1.d0))*(s1**(usm-1.d0)))
    a=1.d0-s1
    dkgds=usumsr*(-krg/(2.d0*a)-2.d0*(a**0.5d0)*&
     &         ((1.d0-s1**usm)**(2.d0*m-1.d0))*(s1**(usm-1.d0)))
!
!
end subroutine

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

subroutine kfomvc(pr, sr, m, n, usm,&
                  usn, s, s1, krl, krg,&
                  dklds, dkgds)
!
! KFOMVC : CALCUL DES PERMEABILITES RELATIVES
!         PAR FONCTION MUALEM-VAN-GENUCHTEN POUR L EAU
!         ET CUBIQUE POUR LE GAZ
!
    implicit      none
!
! IN
    real(kind=8) :: pr, sr, m, n, usm, usn, s, s1
! OUT
    real(kind=8) :: krl, krg, dklds, dkgds
! LOCAL
    real(kind=8) :: umsr, usumsr, a
!
    s1=(s-sr)/(1.d0-sr)
    umsr=(1.d0-sr)
    usumsr=1.d0/umsr
    krl=(s1**0.5d0)*((1.d0-(1.d0-s1**usm)**m)**2.d0)
    krg=(1.d0-s)**3.d0
    a=1.d0-s1**usm
    dklds=usumsr*(krl/(2.d0*s1)+2.d0*((s1)**0.5d0)*(1.d0-a**m)&
     &       *(a**(m-1.d0))*(s1**(usm-1.d0)))
    a=1.d0-s1
    dkgds=-3.d0*(1-s)**2.d0
!
!
end subroutine

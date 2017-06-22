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

subroutine pcapvg(sr, pr, usm, usn, s1,&
                  pc, dpcds, d2pcds)
!
! PCAPVG : CALCUL DE LA PCAP PAR FORMULE DE VAN-GENUCHTEN
    implicit none
! IN
    real(kind=8) :: sr, pr, usm, usn, s1
! OUT
    real(kind=8) :: pc, dpcds, d2pcds
! LOCAL
    real(kind=8) :: umsr, usumsr, a
    umsr=(1.d0-sr)
    usumsr=1.d0/umsr
    pc=pr*((s1**(-usm)-1.d0)**(usn))
    dpcds=-pr*usn*((usm)/(1.d0-sr))*&
     &              ((s1**(-usm)-1.d0)**(usn-1.d0))*&
     &              (s1**(-usm-1.d0))
    a=s1**(-usm)-1.d0
    d2pcds=pr*usumsr*usumsr*(usn*usm*usm*(usn-1.d0)*&
     &         (a**(usn-2.d0))*(s1**(-2.d0-2.d0*usm))&
     &         +usn*usm*(1.d0+usm)*(a**(usn-1.d0))*(s1**(-2.d0-usm)))
end subroutine

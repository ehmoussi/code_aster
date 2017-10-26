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
                  pc, dpcds)
!
!
implicit none
!
    real(kind=8), intent(in) :: sr, pr, usm, usn, s1
    real(kind=8), intent(out) :: pc, dpcds
!
! --------------------------------------------------------------------------------------------------
!
! THM - Saturation
!
! Compute capillary pressure (and is derivatives) for VAN-GENUCHTEN model
!
! --------------------------------------------------------------------------------------------------
!
! In  sr           : parameter SR
! In  pr           : parameter P
! In  usm          : parameter 1/M (with M=1-1/N)
! In  usn          : parameter 1/N
! In  s1           : (saturation-SMAX)/(1-SMAX)
! Out pc           : capillary pressure
! Out dpcds        : first derivative of capillary pressure
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: umsr, usumsr
!
! --------------------------------------------------------------------------------------------------
!
    umsr   = (1.d0-sr)
    usumsr = 1.d0/umsr
    pc     = pr*((s1**(-usm)-1.d0)**(usn))
    dpcds  = -pr*usn*((usm)/(1.d0-sr))*&
             ((s1**(-usm)-1.d0)**(usn-1.d0))*&
             (s1**(-usm-1.d0))
!
end subroutine

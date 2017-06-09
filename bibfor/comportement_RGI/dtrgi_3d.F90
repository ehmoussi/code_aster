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

subroutine dtrgi_3d(f, dtmin, dalsol, dssol, daft,&
                    dafm, dsf, alsol, ssol, aft,&
                    afm, sf, alf, dtcal, phi,&
                    sr, dalpha, sc, alc, dallib,&
                    dcash, dcsheff, csheff, vsr)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : !      !     choix du pas de temps minimum
!=====================================================================
    implicit none
#include "asterfort/vsolal_3d.h"
#include "asterfort/vsols_3d.h"
    real(kind=8) :: f
    real(kind=8) :: dtmin
    real(kind=8) :: dalsol
    real(kind=8) :: dssol
    real(kind=8) :: daft
    real(kind=8) :: dafm
    real(kind=8) :: dsf
    real(kind=8) :: alsol
    real(kind=8) :: ssol
    real(kind=8) :: aft
    real(kind=8) :: afm
    real(kind=8) :: sf
    real(kind=8) :: alf
    real(kind=8) :: dtcal
    real(kind=8) :: phi
    real(kind=8) :: sr
    real(kind=8) :: dalpha
    real(kind=8) :: sc
    real(kind=8) :: alc
    real(kind=8) :: dallib
    real(kind=8) :: dcash
    real(kind=8) :: dcsheff
    real(kind=8) :: csheff
    real(kind=8) :: vsr
!
    real(kind=8) :: cmin
    real(kind=8) :: dtalsol
    real(kind=8) :: dtssol
    real(kind=8) :: dtaft
    real(kind=8) :: dtafm
    real(kind=8) :: dtsf
    real(kind=8) :: dtmin1
    real(kind=8) :: vmin
    real(kind=8) :: dtallib
    real(kind=8) :: dtcash
!
!
    vmin=1.d-15
    cmin=1.d-10
!
    if ((sf.lt.cmin) .and. (dsf.le.0.d0)) then
        dsf=-vmin
        dtsf=(f*sf)/dabs(dsf)
        dsf=0.d0
    else
        dtsf=(f*sf)/dabs(dsf)
    end if
!
    if ((alf.lt.cmin) .and. (dallib.le.0.d0)) then
        dallib=-vmin
        dtallib=(f*alf)/dabs(dallib)
        dallib=0.d0
    else
        dtallib=(f*alf)/dabs(dallib)
    end if
!
    if (dcash .eq. 0.) then
        dtcash=(f*alf)/vmin
    else
        dtcash=(f*alf)/dabs(dcash)
    end if
!
    if ((aft.lt.cmin) .and. (daft.le.0.d0)) then
        daft=-vmin
        dtaft=(f*aft)/dabs(daft)
        daft=0.d0
    else
        dtaft=(f*aft)/dabs(daft)
    end if
!
    if ((afm.lt.cmin) .and. (dafm.le.0.d0)) then
        dafm=-vmin
        dtafm=(f*afm)/dabs(dafm)
        dafm=0.d0
    else
        dtafm=(f*afm)/dabs(dafm)
    end if
!
!      if ((csheff.lt.cmin).and.(dcsheff.lt.0.d0)) then
!      dcsheff=-vmin
!      dtcsheff=(f*csheff)/dabs(dcsheff)
!      dcsheff=0.d0
!      elseif (dcsheff.eq.0.) then
!      dtcsheff=(f*csheff)/vmin
!      else
!      dtcsheff=(f*csheff)/dabs(dcsheff)
!      end if
!
    call vsolal_3d(dalsol, dallib, daft, dafm, alc,&
                   phi, sr, dalpha, vsr, alsol)
    call vsols_3d(dssol, dsf, daft, dafm, sc,&
                  phi, sr, dalpha, vsr, ssol)
!
    if (dssol .ne. 0.) then
        if (ssol .gt. cmin) then
            dtssol=(f*ssol)/dabs(dssol)
        else
            dtssol=(f*ssol)/dabs(vmin)
            dssol=sc*dalpha/(phi*sr)-ssol*vsr/sr
            dalsol=alc*dalpha/(phi*sr)-alsol*vsr/sr
            dsf=0.d0
            daft=0.d0
            dafm=0.d0
            dallib=0.d0
            dcash=0.d0
        end if
    else
        dtssol=(f*ssol)/dabs(vmin)
    end if
!
    if (dalsol .ne. 0.) then
        if (alsol .gt. cmin) then
            dtalsol=(f*alsol)/dabs(dalsol)
        else
            dtalsol=(f*alsol)/dabs(vmin)
            dalsol=alc*dalpha/(phi*sr)-alsol*vsr/sr
            dssol=sc*dalpha/(phi*sr)-ssol*vsr/sr
            dsf=0.d0
            daft=0.d0
            dafm=0.d0
            dallib=0.d0
            dcash=0.d0
!
        end if
    else
        dtalsol=(f*alsol)/dabs(vmin)
    end if
!
    dtmin1=dmin1(dtalsol,dtssol,dtaft,dtallib,dtafm)
    dtmin=dmin1(dtsf,dtcash,dtcal,dtmin1)
!     dtcsheff,
end subroutine

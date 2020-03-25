! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine irextv(fileFormat,&
                  keywf     , keywfIocc,&
                  lResu     , lField   ,&
                  lmax      , lmin     ,&
                  lsup      , borsup   ,&
                  linf      , borinf)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
!
character(len=16), intent(in) :: keywf
integer, intent(in) :: keywfIocc
aster_logical, intent(in) :: lField, lResu
character(len=8), intent(in) :: fileFormat
aster_logical, intent(out) :: lsup, linf, lmax, lmin
real(kind=8), intent(out) :: borsup, borinf
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Get parameters from user: extremum values (only for RESULTAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  fileFormat       : format of file to print (MED, RESULTAT, etc.)
! In  keywf            : keyword to read
! In  keywfIocc        : keyword index to read
! In  lResu            : flag if datastructure is a result
! In  lField           : flag if datastructure is a field
! Out lmax             : flag to print maximum value on nodes
! Out lmin             : flag to print minimum value on nodes
! Out lsup             : flag if supremum exists
! Out borsup           : value of supremum
! Out linf             : flag if infinum exists
! Out borinf           : value of infinum
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: answer
    integer :: nbOcc
!
! --------------------------------------------------------------------------------------------------
!
    linf   = ASTER_FALSE
    borinf = 0.d0
    lsup   = ASTER_FALSE
    borsup = 0.d0
    lmax   = ASTER_FALSE
    lmin   = ASTER_FALSE
!
! - Read values
!
    if ((lField .or. lResu) .and. (fileFormat.eq.'RESULTAT')) then
        call getvr8(keywf, 'BORNE_INF', iocc=keywfIocc, scal=borinf, nbret=nbOcc)
        linf = nbOcc .ne. 0
        call getvr8(keywf, 'BORNE_SUP', iocc=keywfIocc, scal=borsup, nbret=nbOcc)
        lsup = nbOcc .ne. 0
        answer = ' '
        call getvtx(keywf, 'VALE_MAX', iocc=keywfIocc, scal=answer, nbret=nbOcc)
        if (nbOcc .ne. 0 .and. answer .eq. 'OUI') then
            lmax = ASTER_TRUE
        endif
        answer = ' '
        call getvtx(keywf, 'VALE_MIN', iocc=keywfIocc, scal=answer, nbret=nbOcc)
        if (nbOcc .ne. 0 .and. answer .eq. 'OUI') then
            lmin = ASTER_TRUE
        endif
    endif
!
end subroutine

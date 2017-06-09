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

function jexatr(nomc, noma)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
    character(len=32) :: jexatr
#include "jeveux_private.h"
#include "asterfort/jjallc.h"
#include "asterfort/jjvern.h"
#include "asterfort/utmess.h"
    character(len=*),intent(in) :: nomc, noma
! ----------------------------------------------------------------------
    integer :: lk1zon, jk1zon, liszon, jiszon
    common /izonje/  lk1zon , jk1zon , liszon , jiszon
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
!     ------------------------------------------------------------------
    integer :: numatr
    common /idatje/  numatr
!     ------------------------------------------------------------------
    integer :: idiadd, idlong, idlono, idluti
!-----------------------------------------------------------------------
    integer :: ibacol, ixiadd, ixlong, ixlono, ixluti
!-----------------------------------------------------------------------
    parameter    ( idiadd = 2  ,&
     &                             idlong = 7 ,&
     &               idlono = 8 , idluti = 9  )
!     ------------------------------------------------------------------
    integer :: icre, iret
    character(len=24) :: nom24
    character(len=6) :: nomalu
    character(len=8) :: ch8
    data             ch8      / '$$XATR  ' /
! DEB ------------------------------------------------------------------
!
    nom24 = nomc
    nomalu = noma
    if (nomalu .ne. 'LONCUM' .and. nomalu .ne. 'LONMAX' .and. nomalu .ne. 'LONUTI') then
        call utmess('F', 'JEVEUX1_28', sk=nomalu)
    endif
    icre = 0
    call jjvern(nom24//'        ', icre, iret)
    if (iret .ne. 2) then
        call utmess('F', 'JEVEUX1_29')
    else
        call jjallc(iclaco, idatco, 'L', ibacol)
        if (nomalu .eq. 'LONCUM') then
            ixiadd = iszon ( jiszon + ibacol + idiadd )
            if (ixiadd .ne. 0) then
                call utmess('F', 'JEVEUX1_30')
            endif
            ixlono = iszon ( jiszon + ibacol + idlono )
            if (ixlono .eq. 0) then
                call utmess('F', 'JEVEUX1_63', sk='LONCUM')
            endif
            jexatr = nom24//ch8
            numatr = ixlono
        else if (nomalu .eq. 'LONMAX') then
            ixlong = iszon ( jiszon + ibacol + idlong )
            if (ixlong .eq. 0) then
                call utmess('F', 'JEVEUX1_63', sk='LONMAX')
            endif
            jexatr = nom24//ch8
            numatr = ixlong
        else if (nomalu .eq. 'LONUTI') then
            ixluti = iszon ( jiszon + ibacol + idluti )
            if (ixluti .eq. 0) then
                call utmess('F', 'JEVEUX1_63', sk='LONUTI')
            endif
            jexatr = nom24//ch8
            numatr = ixluti
        endif
    endif
! DEB ------------------------------------------------------------------
end function

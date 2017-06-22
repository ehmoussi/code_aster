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

subroutine dtmbuff(sd_dtm, addrs, level)
    use iso_c_binding, only: c_loc, c_ptr, c_f_pointer
    implicit none
! Save in the internal buffer the addresses of param objects for quick access
!
!  sd_dtm [Obl]: Name of the dtm data structure requested [K24]
! ----------------------------------------------------------------------
! person_in_charge: hassan.berro at edf.fr    
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/crevec.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtmsav.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveut.h"
#include "asterfort/nlbuff.h"
#include "asterfort/nlget.h"
#include "asterfort/nlsav.h"
#include "asterfort/jgetptc.h"

!   ====================================================================
!   = 0 =   Variable declarations and initialization
!   ====================================================================
!
!   -0.1- Input/output arguments
    character(len=*) , intent(in)  :: sd_dtm
    integer, pointer , intent(out) :: addrs(:)
    integer, optional, intent(in)  :: level
!
!   -0.2- Local variables
!   --- For strings copying
    character(len=8) :: sd_dtm_

!   --- For general usage
    integer           :: jbuff, ip, iret, addr, long
    integer           :: ilev, lvl, dec, nbnoli, mxlevel
    character(len=6)  :: k_iocc
    character(len=8)  :: sd_nl
    character(len=24) :: savename
    type(c_ptr) :: pc
    integer, pointer  :: buffnl(:) => null() 
!
#include "dtminc.h"
!
!   Copying the input strings, in order to allow in-command truncated input
    sd_dtm_ = sd_dtm
    nullify(addrs)
!
!   Variable lvl defines the maximum buffer level in the case of per occurence items
    lvl = 1 
    if (present(level)) lvl = level
!
!   ====================================================================
!   = 1 = Validation of the input arguments, distinguishing global vars
!   ====================================================================
    call dtmget(sd_dtm, _NB_NONLI, iscal=nbnoli)
    if (nbnoli.gt.0) then  
        call dtmget(sd_dtm_, _SD_NONL  , kscal=sd_nl)
        call nlget (sd_nl  , _MAX_LEVEL, iscal=mxlevel)
        call nlbuff(sd_nl  ,  buffnl   , level=mxlevel)
        call dtmsav(sd_dtm_, _NL_BUFFER, size(buffnl), ivect=buffnl)
    end if

    call jeexin(sd_dtm_//'.BUFFER.        ',iret)
    if (iret.gt.0) then
        call jelibe(sd_dtm_//'.BUFFER.        ')
        call jedetr(sd_dtm_//'.BUFFER.        ')
    end if
    call crevec(sd_dtm_//'.BUFFER.        ','V V I',2*lvl*_DTM_NBPAR,jbuff)

    call jgetptc(jbuff, pc, vi=zi(1))
    call c_f_pointer(pc, addrs, [2*lvl*_DTM_NBPAR])

    do ip = 1, 2*lvl*_DTM_NBPAR
        addrs(ip) = 0
    end do
    do ilev = 1, lvl
        dec = (ilev-1)*2*_DTM_NBPAR
        do ip = 1, _DTM_NBPAR
            savename = '                        '
            savename(1:8) = sd_dtm_
            if(parind(ip).gt.0) then
                call codent(ilev, 'G', k_iocc)
                savename(9:15) = '.'//k_iocc(1:6)
            else if (ilev.gt.1) then
                goto 10
            end if
            savename(16:24)='.'//params(ip)
            call jeexin(savename, iret)
            if (iret.gt.0) then
                call jeveut(savename, 'E', addr)
                call jelira(savename, 'LONMAX', long)
                addrs(dec+ip) = addr
                addrs(dec+_DTM_NBPAR+ip) = long            
            else if (abs(parind(ip)).eq.1) then
                call crevec(savename, 'V V '//partyp(ip),1, addr)
                addrs(dec+ip) = addr
                addrs(dec+_DTM_NBPAR+ip) = 1            
            end if
10          continue
        end do
    end do

end subroutine

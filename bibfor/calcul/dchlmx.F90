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

subroutine dchlmx(iparg, nin, lpain,&
                  nout, lpaout, taille)

use calcul_module, only : ca_calvoi_, ca_iachii_, ca_iachik_, &
     ca_iachoi_, ca_iachok_, ca_iaoppa_, ca_iawlo2_,&
     ca_igr_, ca_nbelgr_, ca_nbgr_, ca_ligrel_, ca_nuop_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/digde2.h"
#include "asterfort/modatt.h"
#include "asterfort/nbelem.h"
#include "asterfort/nbpara.h"
#include "asterfort/nopara.h"
#include "asterfort/typele.h"

    integer :: nin, nout, taille, iparg
    character(len=8) :: lpain(*), lpaout(*)
!-----------------------------------------------------------------------
!     sorties:
!     taille: dimension du champ_loc (nompar)
!             tient compte des cases "undef"
!             =0 => aucun type_elem ne connait le parametre nompar
! ----------------------------------------------------------------------
    integer :: max
    integer :: iparin, iparou, jceld, debugr
    integer :: npin, npou, te, ipar, nval, mode
    integer :: nbsp, ncdyn, jel, taill1
    character(len=8) :: tych, nopare, nompar
!-------------------------------------------------------------------

    nompar = zk8(ca_iaoppa_-1+iparg)
    taill1 = 0
    taille = 0
    debugr=1
    do 30 ca_igr_ = 1, ca_nbgr_
        te = typele(ca_ligrel_,ca_igr_,1)
        ca_nbelgr_ = nbelem(ca_ligrel_,ca_igr_,1)
        npin = nbpara(ca_nuop_,te,'IN ')
        npou = nbpara(ca_nuop_,te,'OUT')

!       ---in:
!       ------
        do 10 ipar = 1, npin
            nopare = nopara(ca_nuop_,te,'IN ',ipar)
            if (nopare .eq. nompar) then
                iparin = indik8(lpain,nompar,1,nin)
                mode = modatt(ca_nuop_,te,'IN ',ipar)
                nval = digde2(mode)
                tych = zk8(ca_iachik_-1+2* (iparin-1)+1)

!               -- cas des cham_elem potentiellement etendus :
                if (tych(1:4) .eq. 'CHML') then
                    jceld = zi(ca_iachii_-1+11* (iparin-1)+4)

!                   -- cas des cham_elem etendus :
                    if ((zi(jceld-1+3).gt.1) .or. (zi(jceld-1+4).gt.1)) then
                        taill1=0
                        do 11, jel=1,ca_nbelgr_
                        nbsp = zi(jceld-1+zi(jceld-1+4+ca_igr_)+4+4*( jel-1)+1)
                        ncdyn = zi(jceld-1+zi(jceld-1+4+ca_igr_)+4+4*( jel-1)+2)
                        nbsp =max(nbsp,1)
                        ncdyn=max(ncdyn,1)
                        taill1=taill1+nval*ncdyn*nbsp
11                      continue

!                   -- cas des cham_elem non etendus :
                    else
                        taill1=nval*ca_nbelgr_
                    endif
                else
                    taill1=nval*ca_nbelgr_
                endif
                goto 29
            endif
10      continue

!       ---out:
!       ------
        do 20 ipar = 1, npou
            nopare = nopara(ca_nuop_,te,'OUT',ipar)
            if (nopare .eq. nompar) then
                iparou = indik8(lpaout,nompar,1,nout)
                mode = modatt(ca_nuop_,te,'OUT',ipar)
                nval = digde2(mode)
                tych = zk8(ca_iachok_-1+2* (iparou-1)+1)

                if (tych(1:4) .eq. 'CHML') then
!                   -- cas des cham_elem :
                    jceld = zi(ca_iachoi_-1+2*(iparou-1)+1)
                    taill1 = zi(jceld-1+zi(jceld-1+4+ca_igr_)+4)
                else
!                   -- cas des resuelem :
                    taill1 = nval*ca_nbelgr_
                endif
                goto 29
            endif
20      continue
29      continue



        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+4)=taill1
        zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+5)=debugr
        if (ca_calvoi_ .eq. 0) then
            taille = max(taille,taill1)
        else
            taille = taille+taill1
            debugr=debugr+taill1+1
        endif

30  end do

!     -- on ajoute quelques cases pour "undef" :
    if (taille .gt. 0) then
        if (ca_calvoi_ .eq. 0) then
            taille = taille+1
        else
            taille = taille+ca_nbgr_
        endif
    endif


end subroutine

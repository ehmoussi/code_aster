! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine getKinematicValues(keywordFact , ioc         ,&
                              mesh        , nogdsi      , valeType,&
                              lxfem       , noxfem      ,&
                              userDOFNb   , userDOFName ,&
                              userNodeNb  , userNodeName,&
                              cnuddl      , cvlddl      , nbddl)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/wkvect.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/utmess.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
!
character(len=16), intent(in) :: keywordFact
integer, intent(in) :: ioc
character(len=*), intent(in) :: mesh
character(len=8), intent(in) :: nogdsi
character(len=1), intent(in) :: valeType
aster_logical, intent(in) :: lxfem
character(len=19), intent(in) :: noxfem
integer, intent(in) :: userDOFNb
character(len=16), intent(in) :: userDOFName(*)
integer, intent(in) :: userNodeNb
character(len=24), intent(in) :: userNodeName
character(len=24), intent(out) :: cnuddl, cvlddl
integer, intent(out) :: nbddl
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_CINE
!
! Get kinematic values
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idnddl, idvddl, jcmp, idino, jnoxfl
    integer :: iddl, i, nbcmp, i_node, nodeNume, ila, icmp
    character(len=16) :: currentDOF, nodeName
    character(len=2) :: typeJEVEUX
    character(len=16), parameter :: motcle(5) = (/ 'GROUP_MA', 'MAILLE  ',&
                                                   'GROUP_NO', 'NOEUD   ',&
                                                   'TOUT    '/)
!
! --------------------------------------------------------------------------------------------------
!
    nbddl  = 0
    cnuddl = '&&CHARCI.NUMDDL'
    cvlddl = '&&CHARCI.VALDDL'
!
! - Special for XFEM
!
    if (lxfem) then
        call jeveuo(noxfem//'.CNSL', 'L', jnoxfl)
    endif
!
! - Access to list of nodes
!
    call jeveuo(userNodeName, 'L', idino)
!
! - Access to FE catalog
!
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nogdsi), 'L', jcmp)
    call jelira(jexnom('&CATA.GD.NOMCMP', nogdsi), 'LONMAX', nbcmp)
!
! - Create objects
!
    call wkvect(cnuddl, ' V V K8', userDOFNb, idnddl)
    typeJEVEUX = valeType
    if (valeType .eq. 'F') then
        typeJEVEUX = 'K8'
    endif
    call wkvect(cvlddl, ' V V '//typeJEVEUX, userDOFNb, idvddl)
!
! - Read values
!
    do iddl = 1, userDOFNb
        currentDOF = userDOFName(iddl)
        do i = 1, 5
            if (currentDOF .eq. motcle(i)) goto 110
        end do
        zk8(idnddl+nbddl) = currentDOF(1:8)
! ----- Verification que la composante existe dans la grandeur
        icmp = indik8( zk8(jcmp), currentDOF(1:8), 1, nbcmp )
        ASSERT(icmp .ne. 0)
! ----- Pour XFEM : DX=U0 se traduit par une relation lineaire entre plusieurs ddls
!           => AFFE_CHAR_CINE est interdit :
        if (lxfem) then
            if ((currentDOF.eq.'DX') .or. (currentDOF.eq.'DY') .or. (currentDOF.eq.'DZ')) then
                do i_node = 1, userNodeNb
                    nodeNume = zi(idino-1+i_node)
                    if (zl(jnoxfl-1+2*nodeNume)) then
                        call jenuno(jexnum(mesh//'.NOMNOE', nodeNume), nodeName)
                        call utmess('F', 'ALGELINE2_22', nk=2, valk=[currentDOF,nodeName] )
                    endif
                end do
            endif
        endif
        if (valeType .eq. 'R') then
            call getvr8(keywordFact, currentDOF, iocc=ioc, scal=zr(idvddl+nbddl), nbret=ila)
        endif
        if (valeType .eq. 'C') then
            call getvc8(keywordFact, currentDOF, iocc=ioc, scal=zc(idvddl+nbddl), nbret=ila)
        endif
        if (valeType .eq. 'F') then
            call getvid(keywordFact, currentDOF, iocc=ioc, scal=zk8(idvddl+nbddl), nbret=ila)
        endif
        nbddl = nbddl+1
110     continue
    end do

end subroutine

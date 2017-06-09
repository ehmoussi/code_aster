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

subroutine tresu_mail(nommai, tbtxt, refi, iocc,&
                     epsi, crit, llab, ssigne)
    implicit none
#include "asterf_types.h"
#include "asterfort/getvtx.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/tresu_print.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"

    character(len=8), intent(in) :: nommai
    character(len=16), intent(in) :: tbtxt(2)
    integer, intent(in) :: refi
    integer, intent(in) :: iocc
    real(kind=8), intent(in) :: epsi
    character(len=*), intent(in) :: crit
    aster_logical, intent(in) :: llab
    character(len=*), intent(in) :: ssigne
!     entrees:
!        nommai : nom du maillage que l'on veut tester
!        tbtxt  : (1) : reference
!                 (2) : legende
!        refi   : valeur entiere attendue pour l'objet
!        crit   : 'RELATIF' ou 'ABSOLU'(precision relative ou absolue).
!        epsi   : precision esperee
!        llab   : flag d impression des labels
!     sorties:
!      listing ...
! ----------------------------------------------------------------------
!    -- variables locales:
    integer ::  n1, nb1, iexi, igr
    character(len=16) :: cara
    character(len=24) :: nomgr
! ----------------------------------------------------------------------

    call getvtx('MAILLAGE', 'CARA', iocc=iocc, scal=cara, nbret=n1)
    ASSERT(n1.eq.1)


!   -- calcul de la valeur (entiere) a tester : nb1
!   ------------------------------------------------
    if (cara.eq.'NB_MAILLE') then
       call jeexin(nommai//'.NOMMAI', iexi)
       if (iexi.eq.0) then
          nb1=0
          goto 100
       endif
       call jelira(nommai//'.NOMMAI', 'NOMMAX', nb1)

    elseif (cara.eq.'NB_NOEUD') then
       call jeexin(nommai//'.NOMNOE', iexi)
       if (iexi.eq.0) then
          nb1=0
          goto 100
       endif
       call jelira(nommai//'.NOMNOE', 'NOMMAX', nb1)

    elseif (cara.eq.'NB_GROUP_MA') then
       call jeexin(nommai//'.GROUPEMA', iexi)
       if (iexi.eq.0) then
          nb1=0
          goto 100
       endif
       call jelira(nommai//'.GROUPEMA', 'NMAXOC', nb1)

    elseif (cara.eq.'NB_GROUP_NO') then
       call jeexin(nommai//'.GROUPENO', iexi)
       if (iexi.eq.0) then
          nb1=0
          goto 100
       endif
       call jelira(nommai//'.GROUPENO', 'NMAXOC', nb1)

    elseif (cara.eq.'NB_MA_GROUP_MA') then
       nb1=0
       call jeexin(nommai//'.GROUPEMA', iexi)
       if (iexi.eq.0)  goto 100

       call getvtx('MAILLAGE', 'NOM_GROUP_MA', iocc=iocc, scal=nomgr, nbret=n1)
       ASSERT(n1.eq.1)
       call jenonu(jexnom(nommai//'.PTRNOMMAI', nomgr),igr)
       if (igr.eq.0)  goto 100

       call jelira(jexnum(nommai//'.GROUPEMA', igr),'LONMAX',nb1)

    elseif (cara.eq.'NB_NO_GROUP_NO') then
       nb1=0
       call jeexin(nommai//'.GROUPENO', iexi)
       if (iexi.eq.0) goto 100

       call getvtx('MAILLAGE', 'NOM_GROUP_NO', iocc=iocc, scal=nomgr, nbret=n1)
       ASSERT(n1.eq.1)
       call jenonu(jexnom(nommai//'.PTRNOMNOE', nomgr),igr)
       if (igr.eq.0)  goto 100

       call jelira(jexnum(nommai//'.GROUPENO', igr),'LONMAX',nb1)

    else
       ASSERT(.false.)
    endif



!   -- test de la valeur recuperee :
!   ---------------------------------
100 continue

    call tresu_print(tbtxt(1), tbtxt(2), llab, 1, crit,&
                     epsi, ssigne, refi=[refi], vali=nb1)

end subroutine

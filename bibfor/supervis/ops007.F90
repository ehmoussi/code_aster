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

subroutine ops007()
!
!
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jvinfo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
! ----------------------------------------------------------------------
!
!     OPERATEUR DESTRUCTION DE CONCEPT ET D'OBJETS JEVEUX
!
! ----------------------------------------------------------------------
!
    character(len=1) :: klas
    character(len=32) :: kch
    integer :: ifm, niv
    integer :: l
    integer :: ibid
    integer :: iocc, nbocc
    integer :: ipos, npos, jlpos
    integer :: icon, ncon
    integer :: iobj, nobj
    character(len=8), pointer :: liste_co(:) => null()
    character(len=24), pointer :: nomobj(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
    if (niv .gt. 1) ibid = jvinfo('AFFECT', niv)
!
! --- DESTRUCTION DES CONCEPTS
!
    call getfac('CONCEPT', nbocc)
    do 10 iocc = 1, nbocc
        call getvid('CONCEPT', 'NOM', iocc=iocc, nbval=0, nbret=ncon)
        ncon = -ncon
        if (ncon .gt. 0) then
            AS_ALLOCATE(vk8=liste_co, size=ncon)
            call getvid('CONCEPT', 'NOM', iocc=iocc, nbval=ncon, vect=liste_co,&
                        nbret=ibid)
            do 15 icon = 1, ncon
                call jedetc('G', liste_co(icon), 1)
15          continue
            AS_DEALLOCATE(vk8=liste_co)
        endif
10  end do
!
! --- DESTRUCTION DES OBJETS
!
    call getfac('OBJET', nbocc)
    do 20 iocc = 1, nbocc
        call getvtx('OBJET', 'CLASSE', iocc=iocc, scal=klas, nbret=nobj)
        call getvtx('OBJET', 'CHAINE', iocc=iocc, nbval=0, nbret=nobj)
        nobj = -nobj
        AS_ALLOCATE(vk24=nomobj, size=nobj)
        call getvtx('OBJET', 'CHAINE', iocc=iocc, nbval=nobj, vect=nomobj,&
                    nbret=ibid)
        call getvis('OBJET', 'POSITION', iocc=iocc, nbval=0, nbret=npos)
        npos = -npos
        if (npos .lt. nobj) then
            call wkvect('&&OPS007.NIPOSI', 'V V IS', nobj, jlpos)
            do 21 ipos = npos+1, nobj
                zi(jlpos+ipos-1) = 1
21          continue
        else
            call wkvect('&&OPS007.NIPOSI', 'V V IS', npos, jlpos)
        endif
        call getvis('OBJET', 'POSITION', iocc=iocc, nbval=npos, vect=zi(jlpos),&
                    nbret=ibid)
        do 22 iobj = 1, nobj
            kch = nomobj(iobj)
            l = lxlgut(kch)
            if (l .gt. 0) then
                call jedetc(klas, kch(1:l), zi(jlpos+iobj-1))
            endif
22      continue
        AS_DEALLOCATE(vk24=nomobj)
        call jedetr('&&OPS007.NIPOSI')
20  end do
    if (niv .gt. 1) ibid=jvinfo('AFFECT', 0)
    call jedema()
end subroutine

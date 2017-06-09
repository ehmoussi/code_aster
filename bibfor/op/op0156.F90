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

subroutine op0156()
    implicit none
!
!     OPERATEUR :   PROD_MATR_CHAM
!
!     ------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/chpver.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/idensd.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcopy.h"
#include "asterfort/vtcreb.h"
    integer :: n1, iret, ier
    integer :: lmat, jchin, jchout
    character(len=1) :: typmat, typres
    character(len=24) :: valk(2)
    character(len=14) :: numem
    character(len=19) :: pfchn1, pfchn2
    character(len=16) :: type, nomcmd
    character(len=19) :: masse, resu, chamno, chamn2
!     ------------------------------------------------------------------
    call jemarq()
    call infmaj()
!
!     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---
    resu=' '
    call getres(resu, type, nomcmd)
!
!     0. MATRICE :
!     -------------
    call getvid(' ', 'MATR_ASSE', scal=masse, nbret=n1)
    call mtdscr(masse)
    call jeveuo(masse(1:19)//'.&INT', 'E', lmat)
    if (zi(lmat+3) .eq. 1) then
        typmat='R'
    else if (zi(lmat+3).eq.2) then
        typmat='C'
    else
        call utmess('F', 'ALGELINE2_86')
    endif
    call dismoi('NOM_NUME_DDL', masse, 'MATR_ASSE', repk=numem)
    call dismoi('PROF_CHNO', masse, 'MATR_ASSE', repk=pfchn1)
!
!
!     1. CHAM_NO  :
!     -------------
    call getvid(' ', 'CHAM_NO', scal=chamno, nbret=n1)
    call chpver('F', chamno, 'NOEU', '*', ier)
    call jelira(chamno//'.VALE', 'TYPE', cval=typres)
    if (typmat .ne. typres) then
        valk(1)=typmat
        valk(2)=typres
        call utmess('F', 'ALGELINE4_42', nk=2, valk=valk)
    endif
!
    call dismoi('PROF_CHNO', chamno, 'CHAM_NO', repk=pfchn2)
!     -- SI LA NUMEROTATION DE CHAM_NO N'EST PAS LA MEME QUE CELLE DE
!        LA MATRICE, ON CHANGE LA NUMEROTATION DE CHAM_NO.
!        EN APPELANT VTCOPY, ON PERD LA VALEUR DES LAGRANGES
    if (.not.idensd('PROF_CHNO',pfchn1,pfchn2)) then
        valk(1)=pfchn1
        valk(2)=pfchn2
        call utmess('A', 'CALCULEL3_46', nk=2, valk=valk)
        chamn2='&&OP0156.CHAM_NO'
        call vtcreb(chamn2, 'V', typres, nume_ddlz = numem)
        call vtcopy(chamno, chamn2, 'F', ier)
        chamno=chamn2
    endif
    call jeveuo(chamno//'.VALE', 'L', jchin)
!
!
!     3. ALLOCATION DU CHAM_NO RESULTAT :
!     ----------------------------------
    call jeexin(resu//'.VALE', iret)
    if (iret .ne. 0) then
        call utmess('F', 'ALGELINE2_87', sk=resu(1:8))
    endif
    call vtcreb(resu, 'G', typres, nume_ddlz = numem)
    call jeveuo(resu//'.VALE', 'E', jchout)
!
!
!     4. PRODUIT MATRICE X VECTEUR :
!     ----------------------------------
    if (typres .eq. 'R') then
        call mrmult('ZERO', lmat, zr(jchin), zr(jchout), 1,&
                    .true._1)
    else if (typres.eq.'C') then
        call mcmult('ZERO', lmat, zc(jchin), zc(jchout), 1,&
                    .true._1)
    endif
!
!
    call titre()
!
    call jedema()
end subroutine

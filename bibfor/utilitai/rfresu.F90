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
subroutine rfresu()
!
implicit none
!
#include "asterc/getres.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/foattr.h"
#include "asterfort/focrr2.h"
#include "asterfort/focrr3.h"
#include "asterfort/focrrs.h"
#include "asterfort/foimpr.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/lxliis.h"
#include "asterfort/ordonn.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/rsGetOneBehaviourFromResult.h"
#include "asterfort/rsGetOneModelFromResult.h"
#include "asterfort/rsutnc.h"
#include "asterfort/titre.h"
#include "asterfort/utcmp1.h"
#include "asterfort/utmess.h"
#include "asterfort/utnono.h"
#include "asterfort/varinonu.h"
!
! --------------------------------------------------------------------------------------------------
!
!   RECU_FONCTION
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbtrou, numer1(1), l, n1, iret, ivari
    integer :: nm, ngm, npoint, np, nn, npr, ngn
    integer :: nres, ifm, niv, nusp, cellNume
    real(kind=8) :: epsi
    character(len=8) :: k8b, crit, cellName, mesh, intres, model
    character(len=8) :: nodeName, cmpName, nomgd
    character(len=16) :: nomcmd, typcon, fieldName, npresu, variName
    character(len=19) :: funcName, cham19, result
    character(len=24) :: valk(3), groupCellName, groupNodeName, compor
    integer, pointer :: listStore(:) => null()
    integer :: nbStore
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call getres(funcName, typcon, nomcmd)
!
! --- RECUPERATION DU NIVEAU D'IMPRESSION
    call infmaj()
    call infniv(ifm, niv)
!
    call getvtx(' ', 'CRITERE', scal=crit, nbret=n1)
    call getvr8(' ', 'PRECISION', scal=epsi, nbret=n1)
    intres = 'NON     '
    call getvtx(' ', 'INTERP_NUME', scal=intres, nbret=n1)
!
    npoint = 0
    cmpName = ' '
    nodeName = ' '
    cellName = ' '
    groupCellName = ' '
    groupNodeName = ' '
    call getvtx(' ', 'MAILLE', scal=cellName, nbret=nm)
    call getvtx(' ', 'GROUP_MA', scal=groupCellName, nbret=ngm)
    call getvis(' ', 'SOUS_POINT', scal=nusp, nbret=np)
    if (np .eq. 0) nusp = 0
    call getvis(' ', 'POINT', scal=npoint, nbret=np)
    call getvtx(' ', 'NOEUD', scal=nodeName, nbret=nn)
    call getvtx(' ', 'GROUP_NO', scal=groupNodeName, nbret=ngn)
!
!     -----------------------------------------------------------------
!                       --- CAS D'UN RESULTAT ---
!     -----------------------------------------------------------------
!
!
    call getvid(' ', 'RESULTAT ', scal=result, nbret=nres)
!
    if (nres .ne. 0) then
        call getvtx(' ', 'NOM_PARA_RESU', scal=npresu, nbret=npr)
        if (npr .ne. 0) then
            if (intres(1:3) .ne. 'NON') then
                call utmess('F', 'UTILITAI4_21')
            endif
            call focrr3(funcName, result, npresu, 'G', iret)
            goto 10
        endif
!
        call getvtx(' ', 'NOM_CHAM', scal=fieldName, nbret=l)
        call rsutnc(result, fieldName, 1, cham19, numer1, nbtrou)
        if (nbtrou .eq. 0) then
            call utmess('F', 'UTILITAI4_22', sk=fieldName)
        endif
        call dismoi('NOM_MAILLA', cham19, 'CHAMP', repk=mesh)
        call dismoi('NOM_GD', cham19, 'CHAMP', repk=nomgd)
        if (ngn .ne. 0) then
            call utnono(' ', mesh, 'NOEUD', groupNodeName, nodeName, iret)
            if (iret .eq. 10) then
                call utmess('F', 'ELEMENTS_67', sk=groupNodeName)
            else if (iret.eq.1) then
                valk(1) = groupNodeName
                valk(2) = nodeName
                call utmess('A', 'SOUSTRUC_87', nk=2, valk=valk)
            endif
        endif
        if (ngm .ne. 0) then
            call utnono(' ', mesh, 'MAILLE', groupCellName, cellName, iret)
            if (iret .eq. 10) then
                call utmess('F', 'ELEMENTS_73', sk=groupCellName)
            else if (iret.eq.1) then
                valk(1) = cellName
                call utmess('A', 'UTILITAI6_72', sk=valk(1))
            endif
        endif
        call utcmp1(nomgd, ' ', 1, cmpName, ivari, variName)
        if (ivari.eq.-1) then
            ASSERT(fieldName(1:7).eq.'VARI_EL')

! --------- Get list of storing index
            call rs_get_liststore(result, nbStore)
            if (nbStore .ne. 0) then
                AS_ALLOCATE(vi = listStore, size = nbStore)
                call rs_get_liststore(result, nbStore, listStore)
            endif

! --------- Get model (only one !)
            call rsGetOneModelFromResult(result, nbStore, listStore, model)
            if (model .eq. '#PLUSIEURS') then
                call utmess('F', 'RESULT1_4')
            endif

! --------- Get behaviour (only one !)
            call rsGetOneBehaviourFromResult(result, nbStore, listStore, compor)
            if (compor .eq. '#SANS') then
                call utmess('F', 'RESULT1_5')
            endif
            if (compor .eq. '#PLUSIEURS') then
                call utmess('F', 'RESULT1_6')
            endif
            AS_DEALLOCATE(vi = listStore)

! --------- Get name of internal state variables
            call jenonu(jexnom(mesh//'.NOMMAI', cellName), cellNume)
            call varinonu(model , compor  ,&
                          1, [cellNume],&
                          1, variName, cmpName)
            call lxliis(cmpName(2:8), ivari, iret)
            ASSERT(iret .eq. 0)
            ASSERT(cmpName(1:1) .eq. 'V')
        else
            variName=' '
        endif

        if (intres(1:3) .eq. 'NON') then
            call focrrs(funcName, result, 'G', fieldName, cellName,&
                        nodeName, cmpName, npoint, nusp, ivari, variName,&
                        iret)
        else
            call focrr2(funcName, result, 'G', fieldName, cellName,&
                        nodeName, cmpName, npoint, nusp, ivari, variName,&
                        iret)
        endif
!
    endif
 10 continue
    call foattr(' ', 1, funcName)
!     --- VERIFICATION QU'ON A BIEN CREE UNE FONCTION ---
!         ET REMISE DES ABSCISSES EN ORDRE CROISSANT
    call ordonn(funcName, 0)
!
    call titre()
    if (niv .gt. 1) then
        call foimpr(funcName, niv, ifm, 0, k8b)
    endif
!
    call jedema()
end subroutine

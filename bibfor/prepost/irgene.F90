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
subroutine irgene(iocc, resultName, fileFormat, fileUnit, nbnosy,&
                  nosy, nbcmpg, cmpg, paraInNb, paraInName,&
                  nbordr, ordr, nbdisc, disc, nume,&
                  lhist)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/gettco.h"
#include "asterfort/dismoi.h"
#include "asterfort/irpara.h"
#include "asterfort/irparb.h"
#include "asterfort/irvgen.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/titre2.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
integer :: iocc, nbcmpg, nbnosy, cmpg(*), nbordr, nbdisc, ordr(*), nume(*)
integer, intent(in) :: paraInNb, fileUnit
character(len=*), intent(out) :: resultName
character(len=*), intent(in) :: paraInName(*), fileFormat
real(kind=8) :: disc(*)
character(len=*) :: nosy(*)
aster_logical :: lhist
!
! --------------------------------------------------------------------------------------------------
!
!     IMPRESSION D'UN CONCEPT GENERALISE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: resultType
    character(len=19) :: noch19
    character(len=24) :: nomst, nuddl, basemo
    aster_logical :: lordr
    integer :: i, im, iord, ibid
    integer :: iret, isy, itresu, jordr, jtitr, kdesc
    integer :: krefe, kvale, nbmode, nbtitr, paraNb, itcal
    integer, pointer :: desc(:) => null()
    character(len=16), pointer :: paraName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!    
    call jemarq()
    nomst = '&&IRGENE.SOUS_TITRE.TITR'
!
    call gettco(resultName, resultType)
!
!=======================================================================
!
!               --- IMPRESSION D'UNE SD VECT_ASSE_GENE ---
!
!=======================================================================
    if (resultType .eq. 'VECT_ASSE_GENE') then
!
        call irvgen(resultName, fileUnit, nbcmpg, cmpg, lhist)
!
!=======================================================================
!
!         --- IMPRESSION D'UNE SD MODE_GENE ---
!
!=======================================================================
    else if (resultType .eq. 'MODE_GENE') then
! ----- Get list of parameters
        call irparb(resultName, paraInNb, paraInName, '&&IRGENE.PARAMETRE', paraNb)
        call jeexin('&&IRGENE.PARAMETRE', iret)
        if (iret .gt. 0) then
            call jeveuo('&&IRGENE.PARAMETRE', 'L', vk16 = paraName)
        else
            paraNb = 0
        endif
        do iord = 1, nbordr
            write(fileUnit,200)
            if (fileFormat .eq. 'RESULTAT') then
            call irpara(resultName, fileUnit  ,&
                        1         , ordr(iord),&
                        paraNb    , paraName  ,&
                        'L')
            endif
            do isy = 1, nbnosy
                call rsexch(' ', resultName, nosy(isy), ordr(iord), noch19,&
                            iret)
                if (iret .eq. 0) then
                    call titre2(resultName, noch19, nomst, 'GENE', iocc,&
                                '(1PE12.5)', nosy(isy), ordr(iord))
                    write(fileUnit,201)
                    call jeveuo(nomst, 'L', jtitr)
                    call jelira(nomst, 'LONMAX', nbtitr)
                    write(fileUnit,'(1X,A)') (zk80(jtitr+i-1),i=1,nbtitr)
                    call irvgen(noch19, fileUnit, nbcmpg, cmpg, lhist)
                endif
            end do
        end do
        call jedetr('&&IRGENE.PARAMETRE')
        call jeexin(nomst, iret)
        if (iret .ne. 0) call jedetr(nomst)
!
!=======================================================================
!
!             --- IMPRESSION D'UNE SD DYNA_GENE ---
!
!=======================================================================
        elseif ((resultType .eq. 'TRAN_GENE' ) .or.&
                 (resultType .eq.'HARM_GENE')) then
        lordr = .false.
        call jeexin(resultName(1:19)//'.ORDR', iret)
        if (iret .ne. 0) then
            call jeveuo(resultName(1:19)//'.ORDR', 'L', jordr)
            lordr = .true.
        endif
        call jeveuo(resultName(1:19)//'.DESC', 'L', vi=desc)
        nbmode = desc(2)
        noch19 = '&&IRGENE_VECTEUR'
        call wkvect(noch19//'.DESC', 'V V I', 2, kdesc)
        call wkvect(noch19//'.REFE', 'V V K24', 2, krefe)
!
        if (desc(1) .eq. 4) then
            itcal = 1
        else
            itcal = 0
        endif
!
        if (itcal .eq. 1) then
!        --- CAS D'UNE SD HARM_GENE => VALEURS COMPLEXES
            call wkvect(noch19//'.VALE', 'V V C', nbmode, kvale)
        else
            call wkvect(noch19//'.VALE', 'V V R', nbmode, kvale)
        endif
!
        zi(kdesc+1) = nbmode
!
        call dismoi('NUME_DDL', resultName, 'RESU_DYNA', repk=nuddl)
        call jeexin(nuddl(1:14)//'.NUME.DESC', iret)
        call dismoi('BASE_MODALE', resultName, 'RESU_DYNA', repk=basemo, arret='C',&
                    ier=ibid)
!
!       -- TEST POUR LE CAS DE LA SOUS-STRUCTURATION : EXISTENCE DE NUME_DDL_GENE  --
        if ((iret .eq. 0)) nuddl = ' '
        zk24(krefe) = basemo
        zk24(krefe+1) = nuddl
!
        do i = 1, nbdisc
            iord = nume(i)
            write(fileUnit,200)
            do isy = 1, nbnosy
                call jeexin(resultName(1:19)//'.'//nosy(isy)(1:4), iret)
                if (iret .ne. 0) then
                    write(fileUnit,201)
                    write(fileUnit,301) nosy(isy)
                    if (lordr) then
                        if (itcal .eq. 1) then
                            write(fileUnit,321) zi(jordr+iord-1), disc(i)
                        else
                            write(fileUnit,302) zi(jordr+iord-1), disc(i)
                        endif
                    else
                        if (itcal .eq. 1) then
                            write(fileUnit,321) iord, disc(i)
                        else
                            write(fileUnit,302) iord, disc(i)
                        endif
                    endif
                    call jeveuo(resultName(1:19)//'.'//nosy(isy)(1:4), 'L', itresu)
                    do im = 0, nbmode-1
                        if (itcal .eq. 1) then
                            zc(kvale+im) = zc(itresu+(iord-1)*nbmode+im)
                        else
                            zr(kvale+im) = zr(itresu+(iord-1)*nbmode+im)
                        endif
                    end do
                    call irvgen(noch19, fileUnit, nbcmpg, cmpg, lhist)
                endif
            end do
        end do
        call jedetr(noch19//'.DESC')
        call jedetr(noch19//'.REFE')
        call jedetr(noch19//'.VALE')
!
    else
        call utmess('F', 'PREPOST2_51', sk=resultType)
    endif
!
!
200 format(/,1x,'======>')
201 format(/,1x,'------>')
301 format(' VECTEUR GENERALISE DE NOM SYMBOLIQUE  ',a)
302 format(1p,' NUMERO D''ORDRE: ',i8,' INSTANT: ',d12.5)
321 format(1p,' NUMERO D''ORDRE: ',i8,' FREQUENCE: ',d12.5)
!
    call jedema()
end subroutine

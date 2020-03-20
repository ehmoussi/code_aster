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
! aslint: disable=W1303
!
subroutine irpara(resultName, fileUnit ,&
                  storeNb   , storeIndx,&
                  paraNb    , paraName ,&
                  tablFormat)
!
implicit none
!
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=*), intent(in) :: resultName
integer, intent(in) :: fileUnit
integer, intent(in) :: storeNb, storeIndx(*)
integer, intent(in) :: paraNb
character(len=*), intent(in) :: paraName(*)
character(len=1), intent(in) :: tablFormat
!
! --------------------------------------------------------------------------------------------------
!
! Results management
!
! Print list of parameters in a file
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of results datastructure
! In  fileUnit         : index of file (logical unit)
! In  storeNb          : number of storage slots in result
! In  storeIndx        : list of storage slots in result
! In  paraNb           : number of parameters
! In  paraName         : name of parameters
! In  tablFormat       : format of file (FORM_TABL keyord)
!                         'L' => list
!                         'T' => table
!                         'E' => excel
!
! --------------------------------------------------------------------------------------------------
!
    integer :: necri, necrr, iundf
    real(kind=8) :: rundf
    character(len=4) :: ctype, chfin
    character(len=8) :: form1
    character(len=104) :: toto
    character(len=2000) :: titi
    integer :: i, iad, iec, ieci, iecr, ik16
    integer :: ik24, ik32, ik8, ik80, iStore, iPara
    integer :: lk16pa, lk24pa, lk32pa, lk80pa, lk8pa, lnipa, lnrpa
    integer :: neck16, neck24, neck32, neck8, neck80
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    iundf = isnnem()
    rundf = r8vide()
    toto  = ' '
!
    if (paraNb .ne. 0) then
! ----- Get list of parameters: name and value
        necri = 0
        necrr = 0
        neck8 = 0
        neck16 = 0
        neck24 = 0
        neck32 = 0
        neck80 = 0
        call wkvect('&&IRPARA.NOMI_PARA', 'V V K16', paraNb, lnipa)
        call wkvect('&&IRPARA.NOMR_PARA', 'V V K16', paraNb, lnrpa)
        call wkvect('&&IRPARA.NOMK8_PARA', 'V V K16', paraNb, lk8pa)
        call wkvect('&&IRPARA.NOMK16_PARA', 'V V K16', paraNb, lk16pa)
        call wkvect('&&IRPARA.NOMK24_PARA', 'V V K16', paraNb, lk24pa)
        call wkvect('&&IRPARA.NOMK32_PARA', 'V V K16', paraNb, lk32pa)
        call wkvect('&&IRPARA.NOMK80_PARA', 'V V K16', paraNb, lk80pa)
        do iPara = 1, paraNb
            call rsadpa(resultName, 'L', 1, paraName(iPara), storeIndx(1),&
                        1, sjv=iad, styp=ctype, istop=0)
            if (ctype(1:1) .eq. 'I') then
                if (zi(iad) .ne. iundf) then
                   zk16(lnipa+necri) = paraName(iPara)
                   necri = necri + 1
                endif
            else if (ctype(1:1).eq.'R') then
                if (zr(iad) .ne. rundf) then
                    zk16(lnrpa+necrr) = paraName(iPara)
                    necrr = necrr + 1
                endif
            else if (ctype(1:2) .eq. 'K8') then
                zk16(lk8pa+neck8) = paraName(iPara)
                neck8 = neck8 + 1
            else if (ctype(1:3) .eq. 'K16') then
                zk16(lk16pa+neck16) = paraName(iPara)
                neck16 = neck16 + 1
            else if (ctype(1:3) .eq. 'K24') then
                zk16(lk24pa+neck24) = paraName(iPara)
                neck24 = neck24 + 1
            else if (ctype(1:3) .eq. 'K32') then
                zk16(lk32pa+neck32) = paraName(iPara)
                neck32 = neck32 + 1
            else if (ctype(1:3) .eq. 'K80') then
                zk16(lk80pa+neck80) = paraName(iPara)
                neck80 = neck80 + 1
            else
                ASSERT(ASTER_FALSE)
            endif
        end do
! ----- Print parameters
        write(fileUnit,'(/)')
        if (tablFormat .eq. 'L') then
            write(fileUnit,'(1X,3A)') 'IMPRESSION DES PARAMETRES DU CONCEPT ',resultName
            do iStore = 1, storeNb
                write(fileUnit,'(1X,A,I4,/)') 'POUR LE NUMERO D''ORDRE ', storeIndx(iStore)
                if (necri .ne. 0) then
                    do iec = 1, necri
                        call rsadpa(resultName, 'L', 1, zk16(lnipa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,I12)') zk16(lnipa-1+iec)&
                        ,zi(iad)
                    end do
                endif
                if (necrr .ne. 0) then
                    do iec = 1, necrr
                        call rsadpa(resultName, 'L', 1, zk16(lnrpa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,1PE12.5)') zk16(lnrpa-1+&
                        iec), zr(iad)
                    end do
                endif
                if (neck8 .ne. 0) then
                    do iec = 1, neck8
                        call rsadpa(resultName, 'L', 1, zk16(lk8pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,1X,A)') zk16(lk8pa-1+&
                        iec),zk8(iad)
                    end do
                endif
                if (neck16 .ne. 0) then
                    do iec = 1, neck16
                        call rsadpa(resultName, 'L', 1, zk16(lk16pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,1X,A)') zk16(lk16pa-1+&
                        iec),zk16(iad)
                    end do
                endif
                if (neck24 .ne. 0) then
                    do iec = 1, neck24
                        call rsadpa(resultName, 'L', 1, zk16(lk24pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,1X,A)') zk16(lk24pa-1+&
                        iec),zk24(iad)
                    end do
                endif
                if (neck32 .ne. 0) then
                    do iec = 1, neck32
                        call rsadpa(resultName, 'L', 1, zk16(lk32pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A,1X,A)') zk16(lk32pa-1+&
                        iec),zk32(iad)
                    end do
                endif
                if (neck80 .ne. 0) then
                    do iec = 1, neck80
                        call rsadpa(resultName, 'L', 1, zk16(lk80pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(14X,A)') zk16(lk32pa-1+iec)
                        write(fileUnit,'(1X,A)') zk80(iad)
                    end do
                endif
            end do
        else if (tablFormat .eq. 'T') then
            write(fileUnit,'(1X,A,4(1X,A),/,(13X,4(1X,A)))')&
                  'NUMERO_ORDRE',(zk16(lnipa-1+ieci),ieci=1,necri),&
                     (zk16(lnrpa-1+iecr),iecr=1,necrr),&
                     (zk16(lk8pa-1+ik8),ik8=1,neck8),&
                     (zk16(lk16pa-1+ik16),ik16=1,neck16)
            write(fileUnit,'(14X,2(A,9X))') (zk16(lk24pa-1+ik24),ik24=1,neck24)
            write(fileUnit,'(14X,2(A,17X))') (zk16(lk32pa-1+ik32),ik32=1,neck32)
            write(fileUnit,'(1X,A)') (zk16(lk80pa-1+ik80),ik80=1,neck80)
            do iStore = 1, storeNb
                i = 1
                write(toto(i:i+13),100) storeIndx(iStore)
                i=14
                if (necri .ne. 0) then
                    do iec = 1, necri
                        call rsadpa(resultName, 'L', 1, zk16(lnipa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+16),101) zi(iad)
                        i=i+17
                        if (i .ge. 68) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (necrr .ne. 0) then
                    do iec = 1, necrr
                        call rsadpa(resultName, 'L', 1, zk16(lnrpa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+16),102) zr(iad)
                        i=i+17
                        if (i .ge. 68) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (neck8 .ne. 0) then
                    do iec = 1, neck8
                        call rsadpa(resultName, 'L', 1, zk16(lk8pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+16),108) zk8(iad)
                        i=i+17
                        if (i .ge. 68) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (neck16 .ne. 0) then
                    do iec = 1, neck16
                        call rsadpa(resultName, 'L', 1, zk16(lk16pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+16),116) zk16(iad)
                        i=i+17
                        if (i .ge. 68) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (neck24 .ne. 0) then
                    if (i .ne. 14) then
                        write(fileUnit,'(A)') toto
                        toto=' '
                    endif
                    i=14
                    do iec = 1, neck24
                        call rsadpa(resultName, 'L', 1, zk16(lk24pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+24),124) zk24(iad)
                        i=i+25
                        if (i .ge. 50) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (neck32 .ne. 0) then
                    if (i .ne. 14) then
                        write(fileUnit,'(A)') toto
                        toto=' '
                    endif
                    i=14
                    do iec = 1, neck32
                        call rsadpa(resultName, 'L', 1, zk16(lk32pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(toto(i:i+32),132) zk32(iad)
                        i=i+33
                        if (i .ge. 64) then
                            write(fileUnit,'(A)') toto
                            toto=' '
                            i=14
                        endif
                    end do
                endif
                if (neck80 .ne. 0) then
                    if (i .ne. 14) then
                        write(fileUnit,'(A)') toto
                        toto=' '
                    endif
                    do iec = 1, neck80
                        call rsadpa(resultName, 'L', 1, zk16(lk80pa-1+iec), storeIndx(iStore),&
                                    1, sjv=iad, styp=ctype, istop=0)
                        write(fileUnit,'(A)') zk80(iad)
                    end do
                endif
                if (toto .ne. ' ') write(fileUnit,'(A)') toto
            end do
        else if (tablFormat .eq. 'E') then
            titi = ' '
            titi(1:12) = 'NUMERO_ORDRE'
            i = 14
            do ieci = 1, necri
                titi(i:i+15) = zk16(lnipa-1+ieci)
                i = i + 17
            end do
            do iecr = 1, necrr
                titi(i:i+15) = zk16(lnrpa-1+iecr)
                i = i + 17
            end do
            do ik8 = 1, neck8
                titi(i:i+15) = zk16(lk8pa-1+ik8)
                i = i + 17
            end do
            do ik16 = 1, neck16
                titi(i:i+15) = zk16(lk16pa-1+ik16)
                i = i + 17
            end do
            do ik24 = 1, neck24
                titi(i:i+15) = zk16(lk24pa-1+ik24)
                i = i + 25
            end do
            do ik32 = 1, neck32
                titi(i:i+15) = zk16(lk32pa-1+ik32)
                i = i + 33
            end do
            do ik80 = 1, neck80
                titi(i:i+15) = zk16(lk80pa-1+ik80)
                i = i + 81
            end do
            call codent(i, 'G', chfin)
            form1 = '(A'//chfin//')'
            write(fileUnit,form1) titi(1:i)
!
            do iStore = 1, storeNb
                titi = ' '
                write(titi(1:12),'(I12)') storeIndx(iStore)
                i = 14
                do iec = 1, necri
                    call rsadpa(resultName, 'L', 1, zk16(lnipa-1+iec), storeIndx( iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    write(titi(i:i+15),'(I12)') zi(iad)
                    i = i + 17
                end do
                do iec = 1, necrr
                    call rsadpa(resultName, 'L', 1, zk16(lnrpa-1+iec), storeIndx( iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    write(titi(i:i+15),'(1PD12.5)') zr(iad)
                    i = i + 17
                end do
                do iec = 1, neck8
                    call rsadpa(resultName, 'L', 1, zk16(lk8pa-1+iec), storeIndx( iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    titi(i:i+15) = zk8(iad)
                    i = i + 17
                end do
                do iec = 1, neck16
                    call rsadpa(resultName, 'L', 1, zk16(lk16pa-1+iec), storeIndx(iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    titi(i:i+15) = zk16(iad)
                    i = i + 17
                end do
                do iec = 1, neck24
                    call rsadpa(resultName, 'L', 1, zk16(lk24pa-1+iec), storeIndx(iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    titi(i:i+23) = zk24(iad)
                    i = i + 25
                end do
                do iec = 1, neck32
                    call rsadpa(resultName, 'L', 1, zk16(lk32pa-1+iec), storeIndx(iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    titi(i:i+31) = zk32(iad)
                    i = i + 33
                end do
                do iec = 1, neck80
                    call rsadpa(resultName, 'L', 1, zk16(lk80pa-1+iec), storeIndx(iStore),&
                                1, sjv=iad, styp=ctype, istop=0)
                    titi(i:i+79) = zk80(iad)
                    i = i + 81
                end do
                call codent(i, 'G', chfin)
                form1 = '(A'//chfin//')'
                write(fileUnit,form1) titi(1:i)
            end do
        endif
    endif
!
    call jedetr('&&IRPARA.NOMI_PARA')
    call jedetr('&&IRPARA.NOMR_PARA')
    call jedetr('&&IRPARA.NOMK8_PARA')
    call jedetr('&&IRPARA.NOMK16_PARA')
    call jedetr('&&IRPARA.NOMK24_PARA')
    call jedetr('&&IRPARA.NOMK32_PARA')
    call jedetr('&&IRPARA.NOMK80_PARA')
!
100 format(i12,1x)
101 format(i12,5x)
102 format(1pd12.5,5x)
108 format(a,9x)
116 format(a,1x)
124 format(1x,a)
132 format(1x,a)
!
    call jedema()
end subroutine

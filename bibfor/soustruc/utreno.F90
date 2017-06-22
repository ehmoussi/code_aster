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

subroutine utreno(mcf, mcs, iocc, ma, noeud, ok_noeud)
    implicit none
#include "asterf_types.h"
#include "asterfort/getvem.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
#include "asterfort/utnono.h"
    integer :: iocc
    character(len=8) :: ma, noeud
    character(len=*) :: mcf, mcs
    aster_logical, optional :: ok_noeud
!     BUT: RECUPERER UN NOEUD "ORIGINE" OU "EXTREMITE"
!
! IN  : MCF    : MOT CLE FACTEUR
! IN  : MCS    : MOT CLE SIMPLE, ORIGINE OU EXTREMITE
! IN  : IOCC   : NUMERO D'OCCURENCE
! IN  : MA     : NOM DU MAILLAGE
! OUT : NOEUD  : NOM DU NOEUD RECUPERE
!     ------------------------------------------------------------------
    integer :: n1, iret
    character(len=16) :: mcnoeu, mcgrno
    character(len=24) :: valk(2), nogno
    integer :: iarg
!     ------------------------------------------------------------------
    aster_logical :: ok_noeud2
!     ------------------------------------------------------------------
!

    ok_noeud2 = .false.
    noeud = '        '
    
    if (mcs(1:4) .eq. 'ORIG') then
        mcnoeu = 'NOEUD_ORIG'
        mcgrno = 'GROUP_NO_ORIG'
    else if (mcs(1:4) .eq. 'EXTR') then
        mcnoeu = 'NOEUD_EXTR'
        mcgrno = 'GROUP_NO_EXTR'
    else if (mcs(1:4) .eq. 'REFE') then
        mcnoeu = 'NOEUD_REFE'
        mcgrno = 'GROUP_NO_REFE'
    endif
!
    call getvtx(mcf, mcnoeu, iocc=iocc, nbval=0, nbret=n1)
    if (n1 .ne. 0) then
        call getvem(ma, 'NOEUD', mcf, mcnoeu, iocc,&
                    iarg, 1, noeud, n1)
        ok_noeud2 = .true.
    endif
!
    call getvtx(mcf, mcgrno, iocc=iocc, nbval=0, nbret=n1)
    if (n1 .ne. 0) then
        call getvtx(mcf, mcgrno, iocc=iocc, scal=nogno, nbret=n1)
        call utnono(' ', ma, 'NOEUD', nogno, noeud,&
                    iret)
        if (iret .eq. 10) then
            call utmess('F', 'ELEMENTS_67', sk=nogno)
        else if (iret .eq. 1) then
            valk(1) = nogno
            valk(2) = noeud
            call utmess('A', 'SOUSTRUC_87', nk=2, valk=valk)
        endif
        ok_noeud2 = .true.
    endif
    
    if (present(ok_noeud)) ok_noeud=ok_noeud2
!
end subroutine

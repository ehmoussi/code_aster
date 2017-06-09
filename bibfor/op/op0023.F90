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

subroutine op0023()
    implicit none
!     COMMANDE:  TEST_RESU
! ----------------------------------------------------------------------
!     REMARQUES:  RESU:( RESULTAT:
!                        PRECISION: ( PREC1 , PREC2 )          L_R8
!                        CRITERE  : ( CRIT1 , CRIT2 )          L_TXM
!     PREC1 ET CRIT1 SONT LA PRECISION ET LE CRITERE DU TEST
!     PREC2 ET CRIT2 SONT LA PRECISION ET LE CRITERE DE L'EXTRACTION
! ----------------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/r8nnem.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/iunifi.h"
#include "asterfort/trcart.h"
#include "asterfort/trchel.h"
#include "asterfort/trchno.h"
#include "asterfort/trgene.h"
#include "asterfort/trjeve.h"
#include "asterfort/trmail.h"
#include "asterfort/trresu.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
    real(kind=8) :: tstnan, resnan
    integer :: ific, nocc, n
    character(len=8) :: repons
    character(len=16) :: nomfi
!     ------------------------------------------------------------------
!     TEST DU MECANISME DE NAN
    call getvtx(' ', 'TEST_NAN', scal=repons, nbret=n)
    if (repons .eq. 'OUI') then
        tstnan = r8nnem ( )
        resnan = tstnan*1.d0
        if (isnan(resnan)) resnan = 0.d0
    endif

    call infmaj()

    nomfi = ' '
    ific = iunifi('RESULTAT')
    if (.not. ulexis( ific )) then
        call ulopen(ific, ' ', nomfi, 'NEW', 'O')
    endif
    write (ific,1000)


!     --- TRAITEMENT D'UN OBJET JEVEUX  ---
    call getfac('OBJET', nocc)
    if (nocc .ne. 0)  call trjeve(ific, nocc)


!     --- TRAITEMENT D'UN MAILLAGE ---
    call getfac('MAILLAGE', nocc)
    if (nocc .ne. 0)  call trmail(ific, nocc)


!     --- TRAITEMENT D'UN CHAM_NO ---
    call getfac('CHAM_NO', nocc)
    if (nocc .ne. 0)  call trchno(ific, nocc)


!     --- TRAITEMENT D'UN CHAM_ELEM ---
    call getfac('CHAM_ELEM', nocc)
    if (nocc .ne. 0)  call trchel(ific, nocc)


!     --- TRAITEMENT D'UNE CARTE ---
    call getfac('CARTE', nocc)
    if (nocc .ne. 0) call trcart(ific, nocc)


!     --- TRAITEMENT D'UN CONCEPT RESULTAT ---
    call getfac('RESU', nocc)
    if (nocc .ne. 0)  call trresu(ific, nocc)


!     --- TRAITEMENT D'UN CONCEPT GENE ---
    call getfac('GENE', nocc)
    if (nocc .ne. 0)  call trgene(ific, nocc)

    1000 format (/,80 ('-'))
end subroutine

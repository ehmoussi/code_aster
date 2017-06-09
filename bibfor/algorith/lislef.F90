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

subroutine lislef(motfac, iexci, nomfct, typfct, phase,&
                  npuis)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/exisd.h"
#include "asterfort/focstc.h"
#include "asterfort/focste.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lispcp.h"
    character(len=16) :: motfac, typfct
    integer :: iexci
    character(len=8) :: nomfct
    real(kind=8) :: phase
    integer :: npuis
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! LECTURE DES INFOS SUR LA FONCTION MULTIPLICATRICE
!
! ----------------------------------------------------------------------
!
!
! IN  MOTFAC : MOT-CLEF FACTEUR DES EXCITATIONS
! IN  IEXCI  : OCCURRENCE DE L'EXCITATION
! OUT NOMFCT : NOM DE LA FONCTION MULTIPLICATRICE
! OUT TYPFCT : TYPE DE LA FONCTION MULTIPLICATRICE
!              'FONCT_REEL' FONCTION MULTIPLICATRICE REELLE
!              'FONCT_COMP' FONCTION MULTIPLICATRICE COMPLEXE
!              'CONST_REEL' FONCTION MULTIPLICATRICE CONSTANTE REELLE
!              'CONST_COMP' FONCTION MULTIPLICATRICE CONSTANTE COMPLEXE
! OUT PHASE  : PHASE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
! OUT NPUIS  : PUISSANCE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
!
! ----------------------------------------------------------------------
!
    character(len=24) :: k24bid
    integer :: nccplx, ncreel
    character(len=4) :: knum
    character(len=8) :: fctcsr
    complex(kind=8) :: ccoef
    real(kind=8) :: rcoef, icoef
    integer :: iret, ibid
    integer :: eximcp
    integer :: nfcplx, nfreel
    aster_logical :: lcrfcr, lcrfcc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- DETECTION DES CAS
!
    eximcp = getexm(motfac,'FONC_MULT_C')
    nfcplx = 0
    fctcsr = '&&LISLEF'
    nfreel = 0
    typfct = ' '
    lcrfcr = .false.
    lcrfcc = .false.
    phase = 0.d0
    npuis = 0
    typfct = ' '
!
! --- TYPE DE FONCTION MULTIPLICATRICE PRESENTE: REELLE OU COMPLEXE ?
!
    call getvid(motfac, 'FONC_MULT', iocc=iexci, scal=k24bid, nbret=nfreel)
    if (eximcp .eq. 1) then
        call getvid(motfac, 'FONC_MULT_C', iocc=iexci, scal=k24bid, nbret=nfcplx)
    endif
!
! --- FONCTIONS MULTIPLICATIVES DES CHARGES - CAS COMPLEXE
!
    if (eximcp .eq. 1) then
        if (nfcplx .ne. 0) then
            call getvid(motfac, 'FONC_MULT_C', iocc=iexci, scal=nomfct, nbret=ibid)
            typfct = 'FONCT_COMP'
        else if (nfreel.ne.0) then
            call getvid(motfac, 'FONC_MULT', iocc=iexci, scal=nomfct, nbret=ibid)
            typfct = 'FONCT_REEL'
        else if ((nfcplx.eq.0).and.(nfreel.eq.0)) then
            call getvc8(motfac, 'COEF_MULT_C', iocc=iexci, scal=ccoef, nbret=nccplx)
            if (nccplx .eq. 0) then
                call getvr8(motfac, 'COEF_MULT', iocc=iexci, scal=rcoef, nbret=ncreel)
                ASSERT(ncreel.ne.0)
                lcrfcr = .true.
            else
                rcoef = dble (ccoef)
                icoef = dimag(ccoef)
                lcrfcc = .true.
            endif
        else
            ASSERT(.false.)
        endif
        goto 99
    endif
!
! --- FONCTIONS MULTIPLICATIVES DES CHARGES - CAS REEL
!
    if (nfreel .eq. 0) then
        rcoef = 1.d0
        lcrfcr = .true.
    else
        call getvid(motfac, 'FONC_MULT', iocc=iexci, scal=nomfct, nbret=ibid)
        typfct = 'FONCT_REEL'
    endif
!
 99 continue
!
! --- CREATION FONCTION CONSTANTE REELLE
!
    if (lcrfcr) then
        if (rcoef .eq. 1.d0) then
            call exisd('FONCTION', fctcsr, iret)
            if (iret .eq. 0) then
                call focste(fctcsr, 'TOUTRESU', rcoef, 'V')
            endif
            nomfct = fctcsr
        else
            call codent(iexci, 'D0', knum)
            ASSERT(iexci.le.9999)
            nomfct = '&&NC'//knum
            call focste(nomfct, 'TOUTRESU', rcoef, 'V')
        endif
        typfct = 'CONST_REEL'
    endif
!
! --- CREATION FONCTION CONSTANTE COMPLEXE
!
    if (lcrfcc) then
        rcoef = dble (ccoef)
        icoef = dimag(ccoef)
        call codent(iexci, 'D0', knum)
        ASSERT(iexci.le.9999)
        nomfct = '&&NC'//knum
        call focstc(nomfct, 'TOUTRESU', rcoef, icoef, 'V')
        typfct = 'CONST_COMP'
    endif
!
! --- RECUP. PULSATION ET PUISSANCE
!
    call lispcp(motfac, iexci, phase, npuis)
!
    ASSERT(typfct.ne.' ')
    ASSERT(nomfct.ne.' ')
!
    call jedema()
end subroutine

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

subroutine facmtr(matin, matout, ier)
!    P. RICHARD     DATE 23/11/90
!-----------------------------------------------------------------------
!  BUT: DELIVRER UN MATRICE FACTORISEE LDLT ET GENERATION DE
    implicit none
!            SON NOM
!
!       CODE RETOUR:    0  TOUT S'EST BIEN PASSE
!                      -1  PRESENCE DE MODES DE CORPS SOLIDES
!                      -2  PRESENCE PROBABLE DE MODES DE CORPS SOLIDES
!-----------------------------------------------------------------------
!
! MATIN    /I/: NOM UTILISATEUR MATRICE BLOC EN ENTREE
! MATOUT   /I/: NOM UTILISATEUR MATRICE FACTORISEE EN SORTIE
! IER      /O/: CODE RETOUR
!
!
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mtcopy.h"
#include "asterfort/mtdefs.h"
#include "asterfort/mtdscr.h"
#include "asterfort/mtexis.h"
#include "asterfort/preres.h"
#include "asterfort/utmess.h"
    character(len=19) :: matin, matout, matpre, solveu
    character(len=24) :: valk
    aster_logical :: hplog
    integer :: ibid
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ier, ire
!-----------------------------------------------------------------------
    call jemarq()
    if (matin .eq. ' ') goto 9999
    hplog=.false.
    if (matin(1:19) .ne. matout(1:19)) hplog=.true.
!
!---------CONTROLE D'EXISTENCE DE LA MATRICE----------------------------
!
    call mtexis(matin, ier)
    if (ier .eq. 0) then
        valk = matin
        call utmess('F', 'ALGORITH12_39', sk=valk)
    endif
!
!
!    SI LA FACTORISATION EST HORS PLACE
!
    if (hplog) then
        call mtdefs(matout, matin, 'V', ' ')
        call mtcopy(matin, matout, ier)
        if (ier .gt. 0) then
            valk = matin
            call utmess('F', 'ALGORITH13_10', sk=valk)
        endif
        call mtdscr(matout)
    endif
!
!
!     -- FACTORISATION EN PLACE DE LA MATRICE DUPLIQUEE :
    solveu='&&OP0099.SOLVEUR'
    matpre='&&OP0099.MATPRE'
    call preres(solveu, 'V', ire, matpre, matout,&
                ibid, -9999)
!
!
!
    if (ire .gt. 1) then
        call utmess('F', 'ALGORITH13_11')
        ier=-1
    else if (ire.eq.1) then
        ier=-2
    endif
!
9999 continue
    call jedema()
end subroutine

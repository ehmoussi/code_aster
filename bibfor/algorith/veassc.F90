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

subroutine veassc(lischa, vecele)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/corich.h"
#include "asterfort/exisd.h"
#include "asterfort/gcnco2.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/liscva.h"
#include "asterfort/lisico.h"
#include "asterfort/lislco.h"
#include "asterfort/lisllc.h"
#include "asterfort/lisnbg.h"
#include "asterfort/lisnnb.h"
#include "asterfort/reajre.h"
    character(len=19) :: lischa
    character(len=19) :: vecele
!
! ----------------------------------------------------------------------
!
! CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
!
! VECT_ASSE_CHAR
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! OUT VECELE : VECT_ELEM RESULTAT
!
! ----------------------------------------------------------------------
!
    integer :: ichar, nbchar, ibid
    character(len=8) :: newnom
    character(len=19) :: chamno, lchout
    character(len=13) :: prefob
    integer :: genrec
    aster_logical :: lveac
    integer :: nbveac, iexis
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    newnom = '.0000000'
!
! --- NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
!
! --- NOMBRE DE CHARGES DE TYPE VECT_ASSE_CHAR
!
    nbveac = lisnbg(lischa,'VECT_ASSE_CHAR')
    if (nbveac .eq. 0) goto 99
!
! --- BOUCLE SUR LES CHARGES
!
    do 10 ichar = 1, nbchar
!
! ----- CODE DU GENRE DE LA CHARGE
!
        call lislco(lischa, ichar, genrec)
        lveac = lisico('VECT_ASSE_CHAR',genrec)
        if (lveac) then
!
! ------- NOM DU CHAM_NO
!
            call lisllc(lischa, ichar, prefob)
            call liscva(prefob, chamno)
!
! ------- NOM DU CHAMP
!
            call exisd('CHAMP_GD', chamno, iexis)
            ASSERT(iexis.gt.0)
!
! ------- ON RECOPIE SIMPLEMENT LE CHAMP DANS VECT_ELEM
!
            call gcnco2(newnom)
            lchout = '&&VEASSE.'//newnom(2:8)
            call corich('E', lchout, ichar, ibid)
            call copisd('CHAMP_GD', 'V', chamno, lchout)
            call reajre(vecele, lchout, 'V')
        endif
 10 continue
!
 99 continue
!
    call jedema()
end subroutine

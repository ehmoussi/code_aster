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

subroutine xgrals(noma, ln, lt, grlt, grln)
    implicit none
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/celces.h"
#include "asterfort/cescns.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/x_tmp_ligr.h"
    character(len=8) :: noma
    character(len=19) :: ln, lt, grlt, grln
!
! person_in_charge: samuel.geniaut at edf.fr
!
!                       CALCUL DES GRADIENTS DES LEVEL-SETS
!
!
!    ENTREE :
!              IFM    :   FICHIER D'IMPRESSION
!              MODE   :   OBJET MODELE
!              NOMA   :   OBJET MAILLAGE
!              LN     :   LEVEL SET NORMALE
!              LT     :   LEVEL SET TANGENTE
!
!    SORTIE :
!              GRLN  :   GRADIENT DE LA LEVEL-SET NORMALE
!              GRLT  :   GRADIENT DE LA LEVEL-SET TANGENTE
!
!
    integer :: nchin, ier
    character(len=8) :: lpain(2), lpaout(1)
    character(len=19) :: chgrlt, chgrln, chams, ligrel
    character(len=24) :: lchin(2), lchout(1)
!     ------------------------------------------------------------------
    call jemarq()
!
! - creation d'un LIGREL temporaire pour calcul / option GRAD_NEUT_R 
!
    ligrel = '&&XGRALS.LIGREL    '
    call x_tmp_ligr(noma, ligrel)
!
    chgrlt = '&&OP0112.CHGRLT'
    chgrln = '&&OP0112.CHGRLN'
    chams = '&&OP0112.CHAMS'
!
!     GRADIENT DE LST
!     ---------------
!
    lpain(1)='PGEOMER'
    lchin(1)=noma//'.COORDO'
    lpain(2)='PNEUTER'
    lchin(2)=lt
    lpaout(1)='PGNEUTR'
    lchout(1)=chgrlt
    nchin=2
    call calcul('S', 'GRAD_NEUT_R', ligrel, nchin, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
!
!     PASSAGE D'UN CHAM_ELNO EN UN CHAM_NO
    call celces(lchout(1), 'V', chams)
    call cescns(chams, ' ', 'V', grlt, ' ',&
                ier)
!
    call detrsd('CHAM_ELEM_S', chams)
    call detrsd('CHAM_ELEM'  , chgrlt)
!
!     GRADIENT DE LSN
!     ---------------
!
    lpain(1)='PGEOMER'
    lchin(1)=noma//'.COORDO'
    lpain(2)='PNEUTER'
    lchin(2)=ln
    lpaout(1)='PGNEUTR'
    lchout(1)=chgrln
    nchin=2
    call calcul('S', 'GRAD_NEUT_R', ligrel, nchin, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
!
!     PASSAGE D'UN CHAM_ELNO EN UN CHAM_NO
    call celces(lchout(1), 'V', chams)
    call cescns(chams, ' ', 'V', grln, ' ',&
                ier)
!
    call detrsd('CHAM_ELEM_S', chams)
    call detrsd('CHAM_ELEM'  , chgrln)
    call detrsd('LIGREL'     , ligrel)
!
    call jedema()
end subroutine

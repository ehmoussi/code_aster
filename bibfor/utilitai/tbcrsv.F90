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

subroutine tbcrsv(nomta, baseta, nbpar, nompar, typpar,&
                  nblign)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tbajpa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=*) :: nomta, baseta, nompar(*), typpar(*)
    integer :: nbpar, nblign
!
!      CREATION D'UNE STRUCTURE DE DONNEES "TABLE".
!      LA STRUCTURE D'UNE TABLE :
!       .TBBA : K8  : DEFINITION DE LA BASE
!       .TBNP :  I  : (1) NOMBRE DE PARAMETRES DE LA TABLE
!                     (2) NOMBRE DE LIGNES DE LA TABLE
!       .TBLP : K24 : DECRIT LES PARAMETRES DE LA TABLE
!                     (1) NOM DU PARAMETRE
!                     (2) TYPE DU PARAMETRE
!                     (3) NOM OBJET JEVEUX CONTENANT LES VALEURS
!                     (4) NOM OBJET JEVEUX CONTENANT DES LOGIQUES
!     ------------------------------------------------------------------
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE" A CREER.
! IN  : BASETA : BASE SUR LAQUELLE ON CREE LA "TABLE".
! IN  : NBPAR  : NOMBRE DE PARAMETRE
! IN  : NOMPAR : LISTE DES PARAMETRES
! IN  : TYPPAR : TYPE DES PARAMETRES
! IN  : NBLIGN : NOMBRE DE LIGNE DE LA TABLE
!     ------------------------------------------------------------------
    integer :: jtbba, jtbnp
    character(len=1) :: base
    character(len=19) :: nomtab
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = nomta
!
    if (nomtab(18:19) .ne. '  ') then
        call utmess('F', 'UTILITAI4_75')
    endif
!
    base = baseta(1:1)
    ASSERT(base.eq.'V' .or. base.eq.'G')
!
!     --- CREATION DU .TBBA ---
!
    call wkvect(nomtab//'.TBBA', base//' V K8', 1, jtbba)
    zk8(jtbba) = base
!
!     --- CREATION DU .TBNP ---
!
    call wkvect(nomtab//'.TBNP', base//' V I', 2, jtbnp)
    zi(jtbnp ) = 0
    zi(jtbnp+1) = nblign
!
!     --- INITIALISATION DE LA TABLE ET DIMENSIONNEMENT
!
    call tbajpa(nomtab, nbpar, nompar, typpar)
    call jedema()
end subroutine

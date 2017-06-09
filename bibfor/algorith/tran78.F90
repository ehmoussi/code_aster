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

subroutine tran78(nomres, typres, nomin)
    implicit none
#include "asterfort/bamo78.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/macr78.h"
#include "asterfort/titre.h"
    character(len=8) :: nomres, nomin
    character(len=16) :: typres
!
!
! IN  : NOMRES : NOM UTILISATEUR POUR LA COMMANDE REST_COND_TRAN
! IN  : NOMIN  : NOM UTILISATEUR DU CONCEPT TRAN_GENE AMONT
! IN  : TYPRES : TYPE DE RESULTAT : 'DYNA_TRANS'
!
    character(len=8) :: macrel
    character(len=19) :: trange
!
!-----------------------------------------------------------------------
    integer :: nmc
!-----------------------------------------------------------------------
    call jemarq()
    trange = nomin
    call getvid(' ', 'MACR_ELEM_DYNA', scal=macrel, nbret=nmc)
!
    if (nmc .ne. 0) then
        call macr78(nomres, trange, typres)
    else
        call bamo78(nomres, trange, typres)
    endif
    call titre()
!
    call jedema()
end subroutine

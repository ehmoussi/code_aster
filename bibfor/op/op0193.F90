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

subroutine op0193()
    implicit none
!     OPERATEUR  PROJ_MESU_MODAL
!
!     EXTRAPOLATION DE RESULTATS DE MESURES EXPERIMENTALES SUR UN MODELE
!     NUMERIQUE EN DYNAMIQUE
!     ------------------------------------------------------------------
!
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mpmod2.h"
#include "asterfort/mptran.h"
    integer :: n1, nbmesu, nbmode
!
    character(len=8) :: basemo, nommes
    character(len=24) :: vrange, vnoeud, basepr, vcham
!
!DEB
!
    call jemarq()
    call infmaj()
!
! --- RECUPERATION DE LA BASE DE PROJECTION ---
!
    call getvid('MODELE_CALCUL', 'BASE', iocc=1, scal=basemo, nbret=n1)
!
! --- RECUPERATION DE LA MESURE
!
    call getvid('MODELE_MESURE', 'MESURE', iocc=1, scal=nommes, nbret=n1)
!
! --- PROJECTION SUR LE MODELE NUMERIQUE
!
    call mpmod2(basemo, nommes, nbmesu, nbmode, basepr,&
                vnoeud, vrange, vcham)
!
! --- ECRITURE SD RESULTAT (TRAN_GENE, HARM_GENE OU MODE_GENE)
!
    call mptran(basemo, nommes, nbmesu, nbmode, basepr,&
                vnoeud, vrange, vcham)
!
    call jedema()
!
end subroutine

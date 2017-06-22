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

subroutine op0099()
    implicit none
!  P. RICHARD - DATE 09/07/91
!-----------------------------------------------------------------------
!  BUT : OPERATEUR DE DEFINITION DE BASE MODALE POUR SUPERPOSITION OU
!        SYNTHESE MODALE : DEFI_BASE_MODALE
!
!  DEUX TYPES DE BASE MODALE : CLASSIQUE
!                              RITZ
!
! CLASSIQUE : BASE MODALE DE TYPE MIXTE CRAIG-BAMPTON - MAC-NEAL (1)
! --------
! DETERMINEE A PARTIR D'UNE 'INTERF_DYNA' DE TYPE CONNU ET D'UN OU
! DE 'MODE_MECA' BASES SUR LE MEME 'NUME_DDL'
! L'OPERATEUR POINTE SUR LES MODES CALCULES DU OU DES 'MODE_MECA'
! ET CALCULE LES DEFORMEES STATIQUES IMPOSEES PAR LA DEFINITION
! DES INTERFACES
!
! RITZ: BASE DE RITZ (A RE-DEVELOPPER)
! -----
! L'OPERATEUR COLLECTE TOUS LES RESULTATS ET LES MET SOUS UNE MEME
! NUMEROTATION DITE DE REFERENCE
!
!
!
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/clas99.h"
#include "asterfort/cresol.h"
#include "asterfort/diag99.h"
#include "asterfort/imbamo.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/orth99.h"
#include "asterfort/refe99.h"
#include "asterfort/ritz99.h"
#include "asterfort/titre.h"
    character(len=8) :: nomres
    character(len=16) :: nomope, nomcon
    character(len=19) :: solveu
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
! --- PHASE DE VERIFICATION
!
!-----------------------------------------------------------------------
    integer :: ifm, ioc1, ioc3, ioc4, ioc5, niv
!-----------------------------------------------------------------------
    call infmaj()
    call infniv(ifm, niv)
!
! --- ECRITURE TITRE ET RECUPERATION NOM ARGUMENT
!
    call titre()
    call getres(nomres, nomcon, nomope)
!
! --- CONTROLE DE LA COHERENCE ET CREATION DU .REFE
!
    call refe99(nomres)
!
! --- TYPE DE BASE MODALE CREE
!
    call getfac('CLASSIQUE', ioc1)
    call getfac('RITZ', ioc3)
    call getfac('DIAG_MASS', ioc4)
    call getfac('ORTHO_BASE', ioc5)
!
!
!     -- CREATION DU SOLVEUR :
    solveu='&&OP0099.SOLVEUR'
    call cresol(solveu)
!
!
! --- CAS D'UNE BASE MODALE CLASSIQUE
!
    if (ioc1 .gt. 0) then
        call clas99(nomres)
!
! --- CAS D'UNE BASE MODALE DE RITZ
!
    else if (ioc3.gt.0) then
        call ritz99(nomres)
        call orth99(nomres, 1)
!
! --- CAS D'UNE DIAGONALISATION DE LA MASSE
!
    else if (ioc4.gt.0) then
!
        call diag99(nomres)
!
    else if (ioc5.gt.0) then
!
        call orth99(nomres, 0)
    endif
!
!
! --- IMPRESSION SUR FICHIER
    if (niv .gt. 1) call imbamo(nomres)
!
!
end subroutine

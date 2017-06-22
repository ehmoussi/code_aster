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

subroutine vechms(nomo, mate, carele, varplu, lischa,&
                  partps, vecele)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/exixfe.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisico.h"
#include "asterfort/lislch.h"
#include "asterfort/lislco.h"
#include "asterfort/lisnbg.h"
#include "asterfort/lisnnb.h"
#include "asterfort/lisnol.h"
#include "asterfort/vechmp.h"
#include "asterfort/vechmx.h"
    character(len=8) :: nomo
    character(len=24) :: mate, carele
    real(kind=8) :: partps(3)
    character(len=19) :: lischa, varplu
    character(len=19) :: vecele
!
! ----------------------------------------------------------------------
!
! CALCUL DES VECTEURS ELEMENTAIRES DES CHARGEMENTS MECANIQUES
! DE NEUMANN STANDARD (VOIR DEFINITION DANS LISDEF)
!
! CALCUL EFFECTIF - BOUCLE SUR LES CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  NOMO   : NOM DU MODELE
! IN  LISCHA : SD LISTE DES CHARGES
! IN  PARTPS : TABLEAU DONNANT T+, DELTAT ET THETA (POUR LE THM)
! IN  CARELE : CARACTERISTIQUES DES POUTRES ET COQUES
! IN  MATE   : MATERIAU CODE
! IN  VARPLU : VARIABLES DE COMMANDE A L'INSTANT T+
! IN  nbin_maxi   : NOMBRE MAXI DE CHAMPS D'ENTREE
! IN  LPAIN  : LISTE DES PARAMETRES IN
! IN  LCHIN  : LISTE DES CHAMPS IN
! IN  LASTIN : NOMBRE EFFECTIF DE CHAMPS IN
! OUT VECELE : VECT_ELEM RESULTAT
!
! ----------------------------------------------------------------------
!
    integer :: nbin_maxi
    parameter    (nbin_maxi=42)
    character(len=8) :: lpain(nbin_maxi)
    character(len=19) :: lchin(nbin_maxi)
!
    integer :: ichar, nbchar, lastin
    character(len=8) :: nomch0
    character(len=24) :: nomlis
    integer :: genrec, ier
    aster_logical :: lneum, lxfem
    integer :: nbch, nbneum
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nomlis = '&&NOMLIS'
    call exixfe(nomo, ier)
    lxfem = ier.ne.0
    call detrsd('VECT_ELEM', vecele)
!
! --- NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
!
! --- NOMBRE DE CHARGES DE TYPE NEUMANN MECANIQUE
!
    nbneum = lisnbg(lischa,'NEUM_MECA')
    if (nbneum .eq. 0) goto 99
!
! --- CHAMPS D'ENTREES STANDARDS
!
    call vechmp(nomo, mate, carele, varplu, lxfem,&
                partps, nbin_maxi, lpain, lchin, lastin)
!
! --- LISTE DES INDEX DES CHARGES
!
    call lisnol(lischa, 'NEUM_MECA', nomlis, nbch)
    ASSERT(nbch.gt.0)
!
! --- CALCUL
!
    do ichar = 1, nbchar
        call lislco(lischa, ichar, genrec)
        lneum = lisico('NEUM_MECA',genrec)
        if (lneum) then
!
! ------- CALCUL DE LA CHARGE ?
!
            call lislch(lischa, ichar, nomch0)
!
! ------- BOUCLE SUR LES TOUS LES TYPES DE CHARGE PREVUS
!
            call vechmx(nomo, lischa, ichar, nbch, nomlis,&
                        nbin_maxi, lpain, lchin, lastin, vecele)
        endif
    end do
!
 99 continue
!
    call jedetr(nomlis)
!
    call jedema()
end subroutine

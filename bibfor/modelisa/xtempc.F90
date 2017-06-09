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

subroutine xtempc(nfiss, fiss, fonree, char)
    implicit none
#include "jeveux.h"
#include "asterfort/aflrch.h"
#include "asterfort/afrela.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: nfiss
    character(len=8) :: fiss(nfiss), char
    character(len=4) :: fonree
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (AFFE_CHAR_THER)
!
! ANNULER LES DDLS X-FEM ASSOCIES AUX FISSURES FISS(1:NFISS)
! -> AFFE_CHAR_THER   / ECHANGE_PAROI / FISSURE / TEMP_CONTINUE
! -> AFFE_CHAR_THER_F / ECHANGE_PAROI / FISSURE / TEMP_CONTINUE
!
! ----------------------------------------------------------------------
!
! IN     NFISS  : NOMBRE DE FISSURES
! IN     FISS   : LISTE DES NOMS DES FISSURES
! IN     FONREE : 'REEL' OU 'FONC'
! IN-OUT CHAR   : NOM UTILISATEUR DU CONCEPT DE CHARGE
!
! ----------------------------------------------------------------------
!
    character(len=19) :: lisrel, stano
    character(len=8) :: noma, nomo, betaf, nomnoe(1), ddlh(1), ddle(1)
    character(len=4) :: typval
    complex(kind=8) :: cbid
    integer :: nrel, ifiss,  nbno, ino, istan, ndim(1)
    real(kind=8) :: betar, coefr(1)
    integer, pointer :: vale(:) => null()
!
    data ddlh /'H1'/
    data ddle /'E1'/
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    lisrel = '&&CXTEMPC.RLISTE'
    nrel = 0
!
! --- INITIALISATION DES ARGUMENTS IN COMMUNS POUR APPEL A AFRELA
!
    ndim(1) = 0
    coefr(1) = 1.d0
    ASSERT(fonree.eq.'REEL' .or. fonree.eq.'FONC')
    typval = fonree
    betar = 0.d0
    betaf = '&FOZERO'
!
! --- MAILLAGE ET MODELE
!
    call dismoi('NOM_MODELE', char(1:8), 'CHARGE', repk=nomo)
    call dismoi('NOM_MAILLA', nomo, 'MODELE', repk=noma)
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbno)
!
!     ---------------------------------------
! --- BOUCLE SUR LES FISSURES
!     ---------------------------------------
!
    do ifiss = 1, nfiss
!
        stano=fiss(ifiss)//'.STNO'
        call jeveuo(stano//'.VALE', 'L', vi=vale)
!
!       -------------------------------------
! ----- BOUCLE SUR LES NOEUDS DU MAILLAGE
!       -------------------------------------
!
        do ino = 1, nbno
            istan = abs(vale(ino))
            if (istan .gt. 0) then
                call jenuno(jexnum(noma(1:8)//'.NOMNOE', ino), nomnoe(1))
!
!           MISE A ZERO DDL HEAVISIDE
                if (istan .eq. 1) then
                    call afrela(coefr, [cbid], ddlh, nomnoe, ndim,&
                                [0.d0], 1, betar, cbid, betaf,&
                                'REEL', typval, '12', 0.d0, lisrel)
                    nrel = nrel + 1
!
!           MISE A ZERO DDL CRACK-TIP
                else if (istan.eq.2) then
                    call afrela(coefr, [cbid], ddle, nomnoe, ndim,&
                                [0.d0], 1, betar, cbid, betaf,&
                                'REEL', typval, '12', 0.d0, lisrel)
                    nrel = nrel + 1
!
!           MISE A ZERO DDLS HEAVISIDE ET CRACK-TIP
                else if (istan.eq.3) then
                    call afrela(coefr, [cbid], ddlh, nomnoe, ndim,&
                                [0.d0], 1, betar, cbid, betaf,&
                                'REEL', typval, '12', 0.d0, lisrel)
                    call afrela(coefr, [cbid], ddle, nomnoe, ndim,&
                                [0.d0], 1, betar, cbid, betaf,&
                                'REEL', typval, '12', 0.d0, lisrel)
                    nrel = nrel + 2
                else
                    ASSERT(.false.)
                endif
!
            endif
!
        end do
!       -------------------------------------
! ----- FIN BOUCLE SUR LES NOEUDS DU MAILLAGE
!       -------------------------------------
    end do
!     ---------------------------------------
! --- FIN BOUCLE SUR LES FISSURES
!     ---------------------------------------
!
! --- AFFECTATION DES RELATIONS LINEAIRES DANS LE LIGREL DE CHARGE
!
    ASSERT(nrel.gt.0)
    call aflrch(lisrel, char, 'LIN')
!
    call jedema()
end subroutine

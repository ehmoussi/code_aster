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

subroutine arlcp2(iocc, mail, nomo, typmai, nom1,&
                  nom2, marlel, modarl, jma1, jma2,&
                  tabcor, mailar, proj)
!
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/arlchi.h"
#include "asterfort/cescel.h"
#include "asterfort/detrsd.h"
#include "asterfort/arlclc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedema.h"
!
    aster_logical :: proj
    character(len=16) :: typmai
    character(len=8) :: mail, nomo
    character(len=10) :: nom1, nom2
    character(len=8) :: marlel, modarl, mailar
    character(len=24) :: tabcor
    integer :: iocc
!
! ----------------------------------------------------------------------
! ROUTINE ARLEQUIN
! CALCUL DES MATRICES ELEMENTAIRES DE COUPLAGE ARLEQUIN
! VERSION AVEC APPEL DE CALCUL
! ----------------------------------------------------------------------
!
! IN  MAIL   : NOM DU MAILLAGE
! IN  NOMO   : NOM DU MODELE
! IN  TYPMAI : SD CONTENANT NOM DES TYPES ELEMENTS (&&CATA.NOMTM)
! IN  NOM1   : NOM DE LA SD DE STOCKAGE PREMIER GROUPE
! IN  NOM2   : NOM DE LA SD DE STOCKAGE SECOND GROUPE
!
! OUT MARLEL : MATR_ELEM CREE POUR CHACUNE DES MATRICES DE COUPLAGE
! OUT MODARL : PSEUDO-MODELE
!
    integer :: nbchel
    parameter    (nbchel = 6)
    character(len=19) :: chames(nbchel), chamel(nbchel)
    character(len=19) :: ligarl
    integer :: nncp, iret, jma1, jma2
!
    character(len=6) :: nompro
    parameter   (nompro='ARLCP2')
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    ligarl = modarl(1:8)//'.MODELE'
!
    chames(1) = '&&'//nompro//'.ESFAMI'
    chames(2) = '&&'//nompro//'.ESINFO'
    chames(3) = '&&'//nompro//'.ESREF1'
    chames(4) = '&&'//nompro//'.ESCOO1'
    chames(5) = '&&'//nompro//'.ESREF2'
    chames(6) = '&&'//nompro//'.ESCOO2'
!
    call arlchi(iocc, mail, nomo, nom1, nom2,&
                mailar, typmai, nbchel, chames, jma1,&
                jma2, tabcor, proj)
!
! --- CREATION DES CHAM_ELEM
!
    chamel(1) = '&&'//nompro//'.ELFAMI'
    chamel(2) = '&&'//nompro//'.ELINFO'
    chamel(3) = '&&'//nompro//'.ELREF1'
    chamel(4) = '&&'//nompro//'.ELCOO1'
    chamel(5) = '&&'//nompro//'.ELREF2'
    chamel(6) = '&&'//nompro//'.ELCOO2'
!
! --- TRANSFORMATION DES CHAM_ELEM_S EN CHAM_ELEM
! --- DESTRUCTION DES CHAM_ELEM_S CORRESPONDANT DES QU'ILS NE SONT PLUS
! --- UTILES
!
    call cescel(chames(1), ligarl, 'ARLQ_MATR', 'PFAMILK', 'OUI',&
                nncp, 'V', chamel(1), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(1))
!
    call cescel(chames(2), ligarl, 'ARLQ_MATR', 'PINFORR', 'OUI',&
                nncp, 'V', chamel(2), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(2))
!
    call cescel(chames(3), ligarl, 'ARLQ_MATR', 'PREFE1K', 'OUI',&
                nncp, 'V', chamel(3), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(3))
!
    call cescel(chames(4), ligarl, 'ARLQ_MATR', 'PCOOR1R', 'OUI',&
                nncp, 'V', chamel(4), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(4))
!
    call cescel(chames(5), ligarl, 'ARLQ_MATR', 'PREFE2K', 'OUI',&
                nncp, 'V', chamel(5), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(5))
!
    call cescel(chames(6), ligarl, 'ARLQ_MATR', 'PCOOR2R', 'OUI',&
                nncp, 'V', chamel(6), 'F', iret)
    call detrsd('CHAM_ELEM_S', chames(6))
!
! --- APPEL A CALCUL
!
    if (proj) then
        call arlclc(modarl, nbchel, chamel, marlel)
    endif
!
! --- MENAGE
!
    call jedetr(chamel(1))
    call jedetr(chamel(2))
    call jedetr(chamel(3))
    call jedetr(chamel(4))
    call jedetr(chamel(5))
    call jedetr(chamel(6))
!
    call jedema()
!
end subroutine

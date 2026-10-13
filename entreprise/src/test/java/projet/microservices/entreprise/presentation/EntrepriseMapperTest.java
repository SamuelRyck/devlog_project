package projet.microservices.entreprise.presentation;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertIterableEquals;
import org.junit.jupiter.api.Test;

import projet.microservices.entreprise.application.Entreprise;

class EntrepriseMapperTest {

    @Test
    void shouldMapCreationEntrepriseDTOToEntreprise() {
        // Arrange
        CreationEntrepriseDTO dto = new CreationEntrepriseDTO();
        dto.setNom("Microsoft");
        dto.setIdEmployes(Arrays.asList(1, 2, 3));

        EntrepriseMapper mapper = new EntrepriseMapper();

        // Act
        Entreprise entreprise = mapper.mapCreationEntrepriseDTOToEntreprise(dto);

        // Assert
        assertEquals("Microsoft", entreprise.getNom());
        assertIterableEquals(
                List.of(1L, 2L, 3L),
                entreprise.getIdEmployes()
        );
    }
}

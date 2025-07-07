package utils

import (
	"crypto/sha256"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/patrickmn/go-cache"
	"kodevibe/internal/models"
)

// Cache wraps go-cache for consistent interface
type Cache struct {
	cache *cache.Cache
}

// NewCache creates a new cache instance
func NewCache(ttl time.Duration) *Cache {
	return &Cache{
		cache: cache.New(ttl, ttl*2),
	}
}

func (c *Cache) Get(key string) (interface{}, bool) { return c.cache.Get(key) }
func (c *Cache) Set(key string, value interface{}) { c.cache.Set(key, value, cache.DefaultExpiration) }
func (c *Cache) Clear() { c.cache.Flush() }

// Metrics collects performance metrics
type Metrics struct {
	mu           sync.RWMutex
	scanCount    int64
	scanDuration time.Duration
	vibeMetrics  map[models.VibeType]VibeMetric
}

type VibeMetric struct {
	Count    int64
	Duration time.Duration
	Issues   int64
}

func NewMetrics() *Metrics {
	return &Metrics{
		vibeMetrics: make(map[models.VibeType]VibeMetric),
	}
}

func (m *Metrics) RecordScan(result *models.ScanResult) {
	m.mu.Lock()
	defer m.mu.Unlock()
	m.scanCount++
	m.scanDuration += result.Duration
}

func (m *Metrics) RecordVibeCheck(vibeType models.VibeType, duration time.Duration, issues int) {
	m.mu.Lock()
	defer m.mu.Unlock()
	metric := m.vibeMetrics[vibeType]
	metric.Count++
	metric.Duration += duration
	metric.Issues += int64(issues)
	m.vibeMetrics[vibeType] = metric
}

// GitUtil provides git operations
type GitUtil struct {
	repoPath string
}

func NewGitUtil(repoPath string) *GitUtil {
	return &GitUtil{repoPath: repoPath}
}

func (g *GitUtil) GetStagedFiles() ([]string, error) {
	// Would use go-git library in real implementation
	return []string{}, nil
}

func (g *GitUtil) GetDiffFiles(target string) ([]string, error) {
	// Would use go-git library in real implementation
	return []string{}, nil
}

// Utility functions
func TruncateString(s string, maxLen int) string {
	if len(s) <= maxLen {
		return s
	}
	return s[:maxLen-3] + "..."
}

func HashStrings(strs []string) string {
	hasher := sha256.New()
	for _, s := range strs {
		hasher.Write([]byte(s))
	}
	return fmt.Sprintf("%x", hasher.Sum(nil))[:16]
}

func CreateTempFile(content, filename string) (string, error) {
	tempFile, err := os.CreateTemp("", filename)
	if err != nil {
		return "", err
	}
	defer tempFile.Close()
	
	_, err = tempFile.WriteString(content)
	if err != nil {
		return "", err
	}
	
	return tempFile.Name(), nil
}

func ParseSize(sizeStr string) (int64, error) {
	sizeStr = strings.ToUpper(strings.TrimSpace(sizeStr))
	
	// Extract number and unit
	re := regexp.MustCompile(`^(\d+(?:\.\d+)?)\s*([KMGT]?B?)$`)
	matches := re.FindStringSubmatch(sizeStr)
	if len(matches) != 3 {
		return 0, fmt.Errorf("invalid size format: %s", sizeStr)
	}
	
	size, err := strconv.ParseFloat(matches[1], 64)
	if err != nil {
		return 0, err
	}
	
	unit := matches[2]
	switch unit {
	case "", "B":
		return int64(size), nil
	case "KB", "K":
		return int64(size * 1024), nil
	case "MB", "M":
		return int64(size * 1024 * 1024), nil
	case "GB", "G":
		return int64(size * 1024 * 1024 * 1024), nil
	case "TB", "T":
		return int64(size * 1024 * 1024 * 1024 * 1024), nil
	default:
		return 0, fmt.Errorf("unknown size unit: %s", unit)
	}
}

func FormatSize(size int64) string {
	if size < 1024 {
		return fmt.Sprintf("%d B", size)
	}
	if size < 1024*1024 {
		return fmt.Sprintf("%.1f KB", float64(size)/1024)
	}
	if size < 1024*1024*1024 {
		return fmt.Sprintf("%.1f MB", float64(size)/(1024*1024))
	}
	return fmt.Sprintf("%.1f GB", float64(size)/(1024*1024*1024))
}